# SPDX-License-Identifier: GPL-3.0-only
CODEWORD "2drop", 2DROP # ( n2 n1 -- ) STACK: drop NOS and TOS 
  lw s3, 4(s4)
  addi s4, s4, 8
  NEXT
