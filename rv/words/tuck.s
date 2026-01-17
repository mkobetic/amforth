# SPDX-License-Identifier: GPL-3.0-only
# -----------------------------------------------------------------------------
  CODEWORD "tuck", TUCK # ( n2 n1 -- n1 n2 n1 ) STACK: Tuck (insert) copy of TOS behind NOS 
# -----------------------------------------------------------------------------
  lw t0, 0(s4)
  addi s4, s4, -4
  sw s3, 4(s4)
  sw t0, 0(s4)
  NEXT
