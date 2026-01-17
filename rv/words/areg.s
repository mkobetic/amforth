# SPDX-License-Identifier: GPL-3.0-only
CODEWORD ">a", TO_A
  mv t3, s3            # set t3=A to TOS
  lw s3, 0(s4)          # set TOS to NOS
  addi s4, s4, 4        # contract stack 
  NEXT

CODEWORD "a>", FROM_A
  addi s4 , s4, -4      # extend stack
  sw   s3 , 0(s4)       # set NOS to TOS
  mv   s3 , t3         # set TO to s6=A
  NEXT

CODEWORD "a++", APLUSPLUS
  addi t3 , t3,  1    # set A=A+1
  NEXT

CODEWORD "a--", AMINUSMINUS
  addi t3 , t3, -1    # set A=A-1
  NEXT
