
.equ PRCI_BASE, 0x10008000

.equ PRCI_HFROSCCFG  , PRCI_BASE + 0x00
.equ PRCI_HFXOSCCFG  , PRCI_BASE + 0x04
.equ PRCI_PLLCFG     , PRCI_BASE + 0x08
.equ PRCI_PLLDIV     , PRCI_BASE + 0x0C
.equ PRCI_PROCMONCFG , PRCI_BASE + 0xF0

CODEWORD "clock", CLOCK

  # set up the clock system and make it run

1:li  t0, PRCI_HFXOSCCFG   # 0x10008004
  lw  t1, 0(t0)
  li  t2, 0xC0000000
  bne t1, t2, 1b

  # Select crystal as main clock source

  li  t0, PRCI_PLLCFG
  li  t1, 0x00070df1 # 0x00060df1 | (1<<16) | (1<<17) | (1<<18)  # Reset value | PLLSEL | PLLREFSEL | PLLBYPASS
  sw  t1, 0(t0)

  NEXT
END CLOCK
