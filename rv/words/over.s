# SPDX-License-Identifier: GPL-3.0-only
CODEWORD "over",OVER # ( n2 n1 -- n2 n1 n2 ) STACK: Insert copy of NOS infront of TOS 
  addi s4, s4, -4
  sw s3, 0(s4)
  lw s3, 4(s4)
  NEXT
