# SPDX-License-Identifier: GPL-3.0-only
CODEWORD ">a", TO_A /* ( n -- ) write to A register */
  mv t3, s3            # set t3=A to TOS
  lw s3, 0(s4)          # set TOS to NOS
  addi s4, s4, 4        # contract stack 
  NEXT
END TO_A

CODEWORD "a>", FROM_A /* ( -- n ) read the A register */
  addi s4 , s4, -4      # extend stack
  sw   s3 , 0(s4)       # set NOS to TOS
  mv   s3 , t3         # set TO to s6=A
  NEXT
END FROM_A

CODEWORD "a++", APLUSPLUS /* ( -- ) increment the A register */
  addi t3 , t3,  1    # set A=A+1
  NEXT
END APLUSPLUS

CODEWORD "a--", AMINUSMINUS /* ( -- ) decrement the A register */
  addi t3 , t3, -1    # set A=A-1
  NEXT
END AMINUSMINUS
