# SPDX-License-Identifier: GPL-3.0-only
# -----------------------------------------------------------------------------
  CODEWORD "rot",ROT # ( z y x  -- y x z ) STACK: Rotate third stack item to TOS 
# -----------------------------------------------------------------------------
  lw t0, 0(s4)
  lw t1, 4(s4)
  sw s3, 0(s4)
  sw t0, 4(s4)
  mv s3, t1
  NEXT
