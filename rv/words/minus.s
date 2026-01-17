# SPDX-License-Identifier: GPL-3.0-only
# -----------------------------------------------------------------------------
  CODEWORD "-", MINUS # ( n2 n1 -- n2-n1 ) MATHS: Subtract TOS from NOS
# -----------------------------------------------------------------------------
  lw t0, 0(s4)
  addi s4, s4, 4
  sub s3, t0, s3
  NEXT
