# SPDX-License-Identifier: GPL-3.0-only
CODEWORD "2dup", 2DUP # ( n2 n1 -- n2 n1 n2 n1 ) STACK: dup NOS and TOS
  lw t0, 0(s4)
  addi s4, s4, -8
  sw s3, 4(s4)
  sw t0, 0(s4)  
  NEXT
