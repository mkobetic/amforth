# From RA4M1 Group: User's Manual (32-bit): 28 Serial Communications Interface (SCI)
#   * only SCI0 and SCI1 support FIFO

# with FIFO
.equ SCI0_BASE, 0x40070000   @ base address of the SCI0 registers
.equ SCI1_BASE, 0x40070020   @ base address of the SCI1 registers
# no FIFO
.equ SCI2_BASE, 0x40070040   @ base address of the SCI2 registers
.equ SCI9_BASE, 0x40070120   @ base address of the SCI9 registers

.macro _sci_registers n
.if \n > 2 && \n != 9
.error "Invalid SCI number"
.endif
@ the \() is necessary to help as recognize the parameter reference
.equ SCI\n\()_SMR, SCI\n\()_BASE + 0x00   @ Serial Mode Register
.equ SCI\n\()_BRR, SCI\n\()_BASE + 0x01   @ Bit Rate Register 
.equ SCI\n\()_SCR, SCI\n\()_BASE + 0x02   @ Serial Control Register
.equ SCI\n\()_TDR, SCI\n\()_BASE + 0x03   @ Transmit Data Register 
.equ SCI\n\()_SSR, SCI\n\()_BASE + 0x04   @ Serial Status Register
.equ SCI\n\()_RDR, SCI\n\()_BASE + 0x05   @ Receive Data Register 
.equ SCI\n\()_SCMR, SCI\n\()_BASE + 0x06  @ Smart Card Mode Register 
.equ SCI\n\()_SEMR, SCI\n\()_BASE + 0x07  @ Serial Extended Mode Register
.equ SCI\n\()_SNFR, SCI\n\()_BASE + 0x08  @ Noise Filter Setting Register
.equ SCI\n\()_SIMR1, SCI\n\()_BASE + 0x09 @ I2C Mode Register 1
.equ SCI\n\()_SIMR2, SCI\n\()_BASE + 0x0A @ I2C Mode Register 2
.equ SCI\n\()_SIMR3, SCI\n\()_BASE + 0x0B @ I2C Mode Register 3
.equ SCI\n\()_SISR, SCI\n\()_BASE + 0x0C  @ I2C Status Register 
.equ SCI\n\()_SPMR, SCI\n\()_BASE + 0x0D  @ SPI Mode Register 
.equ SCI\n\()_TDRHL, SCI\n\()_BASE + 0x0E @ Transmit 9-bit Data Register (16-bit)
.equ SCI\n\()_RDRHL, SCI\n\()_BASE + 0x10 @ Receive 9-bit Data Register (16-bit)
.equ SCI\n\()_MDDR, SCI\n\()_BASE + 0x12  @ Modulation Duty Register
.equ SCI\n\()_DCCR, SCI\n\()_BASE + 0x13  @ Data Compare Match Control Register
.equ SCI\n\()_CDR, SCI\n\()_BASE + 0x1A   @ Compare Match Data Register (16-bit)
.equ SCI\n\()_SPTR, SCI\n\()_BASE + 0x1C  @ Serial Port Register
.if \n < 2
.equ SCI\n\()_FCR, SCI\n\()_BASE + 0x14  @ FIFO Control Register (16-bit)
.equ SCI\n\()_FDR, SCI\n\()_BASE + 0x16  @ FIFO Data Count Register (16-bit)
.equ SCI\n\()_LSR, SCI\n\()_BASE + 0x18  @ Line Status Register (16-bit)
.endif
.endm

_sci_registers 0 @ define the SCI0 registers
_sci_registers 1 @ define the SCI1 registers
_sci_registers 2 @ define the SCI2 registers
_sci_registers 9 @ define the SCI9 registers
