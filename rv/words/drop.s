# SPDX-License-Identifier: GPL-3.0-only

CODEWORD "drop", DROP # ( n -- ) STACK: Drop TOS (so NOS becomes TOS)
  lw s3, 0(s4)
  addi s4, s4, 4
  NEXT
