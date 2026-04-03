.equ UART0BASE, 0x10013000

.equ UART0_TXDATA    , UART0BASE + 0x00
.equ UART0_RXDATA    , UART0BASE + 0x04
.equ UART0_TXCTRL    , UART0BASE + 0x08
.equ UART0_RXCTRL    , UART0BASE + 0x0C
.equ UART0_IE        , UART0BASE + 0x10
.equ UART0_IP        , UART0BASE + 0x14
.equ UART0_DIV       , UART0BASE + 0x18

# ======================================================================

CODEWORD "+usart", INIT_USART

  # UART RX/TX are selected IOF_SEL on Reset. Set IOF_EN bits.

  li t0, GPIO_IOF_EN
  li t1, (1<<17)|(1<<16)
  sw t1, 0(t0)

  # Set baud rate

  li t0, UART0_DIV

  li t1, 2222-1  # 256 MHz / 115200 Baud = 2222.2
  
#  li a1, 6667-1  # 256 MHz / 38400 Baud = 6666.67
#  li t1, 1111-1  # 128 MHz / 115200 Baud = 1111.1
#  li t1, 555-1  #  64 MHz / 115200 Baud = 555.55
#  li t1, 139-1  #  16 MHz / 115200 Baud = 138.89
#  li t1, 417-1  #  16 MHz / 38400 Baud = 416,67
#  li t1, 3300-1 # 128MHz 38400 Baud             

  sw t1, 0(t0)

  # Enable transmit

  li t0, UART0_TXCTRL
  li t1, 1
  sw t1, 0(t0)

  # Enable receive

  li t0, UART0_RXCTRL
  li t1, 1
  sw t1, 0(t0)

  NEXT

  VARIABLE  "serial-lastchar", SERIAL_LASTCHAR # ( -- addr )

# -----------------------------------------------------------------------------
  CODEWORD  "serial-key", SERIAL_KEY
# -----------------------------------------------------------------------------
  savetos
  la t1, PFA_SERIAL_LASTCHAR
  lw t1, 0(t1)
  lw s3, 0(t1)

  li t0, -1
  sw t0, 0(t1)

  NEXT
END INIT_USART

# -----------------------------------------------------------------------------
  CODEWORD  "serial-key?", SERIAL_KEYQ
# -----------------------------------------------------------------------------

  savetos

  # Check buffer for waiting character

  la t1, PFA_SERIAL_LASTCHAR
  lw t0, 0(t1)
  srai s3, t0, 31 # Sign extend the "receive FIFO empty" bit
  beq s3, zero, 1f 

  # No character waiting in the buffer variable. Check UART for new character:

  li t1, UART0_RXDATA
  lw t0, 0(t1)
  la t1, PFA_SERIAL_LASTCHAR
  lw t1, 0(t1)
  sw t0, 0(t1)

  srai s3, t0, 31 # Sign extend the "receive FIFO empty" bit

1:
  xori s3, s3, -1
  NEXT
END SERIAL_KEYQ

# -----------------------------------------------------------------------------
  CODEWORD  "serial-emit", SERIAL_EMIT
# -----------------------------------------------------------------------------

SERIAL_EMIT_WAIT:
  li t0, UART0_TXDATA
  lw t0, 0(t0)
  blt t0,zero, SERIAL_EMIT_WAIT

  li t1, UART0_TXDATA
  sw s3, 0(t1)
  loadtos

  NEXT
END SERIAL_EMIT

# -----------------------------------------------------------------------------
  CODEWORD  "serial-emit?", SERIAL_EMITQ
# -----------------------------------------------------------------------------
  savetos
  li t0, UART0_TXDATA
  lw t0, 0(t0)
  srai t0, t0, 31  # Sign extend the "transmit FIFO full" bit
  xori s3, t0, -1  # Invert it

  NEXT
END SERIAL_EMITQ
