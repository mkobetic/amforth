# Implement serial host connection via SCI9, using non-FIFO async mode
# References:
# * RA4M1 Group: User's Manual (32-bit): 28. Serial Communications Interface (SCI)

# From github.com/arduino/uno-r4-wifi-usb-bridge/UNOR4USBBridge/UNOR4USBBridge.ino
#   Serial1 refers to gpio 20/21 ( -> will become Serial object in RA4 variant P109 / P110) SCI9
#   Serial2 refers to gpio 2/3 ( -> will become SerialNina object in RA4 variant P501 / P502) SCI1
#   #define SERIAL_AT              Serial1
#   SERIAL_AT.begin(115200, SERIAL_8N1, 6, 5);

.include "words/sci.s"

# SCI9 Pins 
.equ RA4M1_P109PFS, 0x40040840 + 4 * 9
.equ RA4M1_P110PFS, 0x40040840 + 4 * 10

CODEWORD  "uart-init", UART_INIT

@ Following 28.3.7. SCI Initialization in Asynchronous Mode
@ Omitting steps that should be set the prescribed way after reset
@ (see also Apendix 3 / Register descriptions)

@ [ 0 ] Set SCR.TIE, RIE, TE, RE, and TEIE to 0
  ldr r0, =SCI9_SCR
  mov r1, #0
  strb r1, [r0]

@ [ 1 ] Set FCR.FM to 0. // FCR only applies to SCI0/1
@ [ 2 ] Set the clock selection in SCR.
@ When clock output is selected in asynchronous mode, the
@ clock is output immediately after SCR settings are made.
@ [ 3 ] Set SIMR1.IICM to 0. Set SPMR.CKPH and SPMR.CKPOL to 0. // I2C & SPI
@ [ 4 ] Set data transmission/reception format in SMR, SCMR, and SEMR.
@ serial settings 8N1 => SMR 0x00 (reset state) & SCMR[4] = 1 (reset state)
@ [ 5 ] Set the communication terminals status in SPTR. (reset state)

@ [ 6 ] Write a value associated with the bit rate to BRR.
@ PCLKA 48MHz, B = 115200 bps, n = 0
@ N = PCLKA * 10^6 / (64 * 2^2n-1 * B) - 1 = 48000000 / (64 * 2^-1 * 115200) - 1 =
@   = 48000000 / (32 * 115200) -1 ~ 12.02
  ldr r0, =SCI9_BRR
  mov r1, #12   @ N = 12 computed above for 115200 bps
  strb r1, [r0]

@ [ 7 ] Write the value obtained by correcting a bit rate error in MDDR.
@ This step is not required if the BRME bit in SEMR is set to 0 or an external clock is used.
@ TODO: We may want to use this to reduce error rates

@ [ 8 ] Specify the I/O port to enable input and output functions as required for TXDn, RXDn, and SCKn pins.
  mov r1, #0  @ Set both pins to SCI peripheral function
  movt r1, #0x0501  @ [24:28]PSEL = SCI(5) & [16]PMR = peripheral function(1)
  ldr r0, =RA4M1_P109PFS
  str r1, [r0]
  ldr r0, =RA4M1_P110PFS
  str r1, [r0]

@ [ 9 ] Set SCR.TE or SCR.RE to 1, also set SCR.TIE and SCR.RIE.
@ Setting SCR.TE and SCR.RE allows TXDn and RXDn to be used.
@ Not using interrupts so we'll be handling TE/RE in the read/write routines
  ldr r0, =SCI9_SCR
  mov r1, #0x30   @ [05]TE || [04]RE
  strb r1, [r0]

NEXT

// Status register (SSR) bits
.equ SCI_SSR_RDRF, 0x40 @ Receive Data Full
.equ SCI_SSR_TDRE, 0x80 @ Transmit Data Empty

@ -----------------------------------------------------------------------------
  CODEWORD  "serial-key", SERIAL_KEY
@ -----------------------------------------------------------------------------

   savetos
  @ Don't read SCI_SSR_RDRF, it was already read by SERIAL_KEYQ and flag is now 0.
  ldr r0, =SCI9_RDR  @ read RDR
  ldrb tos, [r0]  
NEXT

@ -----------------------------------------------------------------------------
  CODEWORD  "serial-key?", SERIAL_KEYQ
@ -----------------------------------------------------------------------------
   savetos
   mov tos, #0
   ldr r0, =SCI9_SSR
   ldrb r1, [r0]
   ands r1, #SCI_SSR_RDRF
   @ TODO: error handling
   bne 1f
     mvns tos, tos
1: 
NEXT

@ -----------------------------------------------------------------------------
  CODEWORD  "serial-emit", SERIAL_EMIT
@ -----------------------------------------------------------------------------

  @ Don't read SCI_SSR_TDRE, it was already read by SERIAL_EMITQ and flag is now 0.
   ldr r0, =SCI9_TDR
   strb tos, [r0]
   loadtos
NEXT

@ -----------------------------------------------------------------------------
  CODEWORD  "serial-emit?", SERIAL_EMITQ
@ -----------------------------------------------------------------------------
   savetos
   mov tos, #0
   ldr r0, =SCI9_SSR
   ldr r1, [r0]
   ands r1, #SCI_SSR_TDRE
   bne 1f
     mvn tos, tos
1:
NEXT
