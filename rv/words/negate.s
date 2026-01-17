# SPDX-License-Identifier: GPL-3.0-only
# -----------------------------------------------------------------------------
  CODEWORD "negate", NEGATE # ( n1 -- -n1 ) MATHS: Multiply TOS by -1 
# -----------------------------------------------------------------------------
  xor s3, s3, -1
  addi s3, s3, 1
  NEXT
