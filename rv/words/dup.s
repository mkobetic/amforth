# SPDX-License-Identifier: GPL-3.0-only

CODEWORD "dup", DUP # ( n -- n n ) STACK: Insert copy of TOS infront of TOS 
  addi s4, s4, -4
  sw s3, 0(s4)
  NEXT
