# SPDX-License-Identifier: GPL-3.0-only
# -----------------------------------------------------------------------------
  CODEWORD "-rot", MROT # ( x w y -- y x w ) STACK: rotate stack so TOS at 3 
# -----------------------------------------------------------------------------
  lw t0, 0(s4)
  lw t1, 4(s4)
  sw t1, 0(s4)
  sw s3, 4(s4)
  mv s3, t0
  NEXT
