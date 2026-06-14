
.equ PRCI_BASE, 0x10008000

.equ PRCI_HFROSCCFG  , PRCI_BASE + 0x00
.equ PRCI_HFXOSCCFG  , PRCI_BASE + 0x04
.equ PRCI_PLLCFG     , PRCI_BASE + 0x08
.equ PRCI_PLLDIV     , PRCI_BASE + 0x0C
.equ PRCI_PROCMONCFG , PRCI_BASE + 0xF0


CODEWORD "cold", COLD

  # set up the clock system and make it run

# 1:li x10, PRCI_HFXOSCCFG   # 0x10008004
#   lw x11, 0(x10)
#   li x12, 0xC0000000
#   bne x11, x12, 1b

#   # Select crystal as main clock source

#   li x10, PRCI_PLLCFG
#   li x11, 0x00070df1 # 0x00060df1 | (1<<16) | (1<<17) | (1<<18)  # Reset value | PLLSEL | PLLREFSEL | PLLBYPASS
#   sw x11, 0(x10)

  # set up the clock system and make it run

1:li  t0, PRCI_HFXOSCCFG   # 0x10008004
  lw  t1, 0(t0)
  li  t2, 0xC0000000
  bne t1, t2, 1b

  # Select crystal as main clock source

  li  t0, PRCI_PLLCFG
  li  t1, 0x00070df1 # 0x00060df1 | (1<<16) | (1<<17) | (1<<18)  # Reset value | PLLSEL | PLLREFSEL | PLLBYPASS
  sw  t1, 0(t0)

  # This is the same as in quit, in order to prepare for whatever the user might want to do within "init".

  la s5, RAM_upper_returnstack
  la s4, RAM_upper_datastack

#  .ifdef initflash
#  call initflash
#  .endif

  la s1, XT_WARM
  j DO_EXECUTE
  
END COLD  
