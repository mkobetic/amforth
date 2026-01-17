# SPDX-License-Identifier: GPL-3.0-only
# Logic.

# -----------------------------------------------------------------------------
  CODEWORD  "and", AND # ( n2 n1 -- n2 & n1 ) LOGIC: TOS is bitwise NOS AND TOS

# -----------------------------------------------------------------------------
  lw t0, 0(s4)
  addi s4, s4, 4
  and s3, t0, s3
  NEXT

# -----------------------------------------------------------------------------
  CODEWORD  "or", OR # ( n2 n1 -- n2 | n1 ) LOGIC: TOS is bitwise NOS OR TOS
                       # Combines the top two stack elements using bitwise OR.
# -----------------------------------------------------------------------------
  lw t0, 0(s4)
  addi s4, s4, 4
  or s3, t0, s3
  NEXT

# I prefer a logical not as below  
# -----------------------------------------------------------------------------
#  CODEWORD  "not", NOT # ( x -- ~x )
# -----------------------------------------------------------------------------
#  xori s3, s3, -1
#  NEXT

COLON "not" , NOT # ( f -- ~f ) LOGIC: if f true ~f false (logical not) 
      .word XT_ZEROEQUAL
      .word XT_EXIT 


# -----------------------------------------------------------------------------
  CODEWORD  "rshift", RSHIFT # ( x n -- x ) LOGIC: shift x right n places (zero fill)
# -----------------------------------------------------------------------------
  lw t0, 0(s4)
  addi s4, s4, 4
  srl s3, t0, s3
  NEXT

  CODEWORD  "lshift", LSHIFT # ( x n -- x ) LOGIC: shift x left n places 
  lw t0, 0(s4)
  addi s4, s4, 4
  sll s3, t0, s3
  NEXT

