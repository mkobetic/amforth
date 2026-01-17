# SPDX-License-Identifier: GPL-3.0-only
# -----------------------------------------------------------------------------
  CODEWORD "2rot", 2ROT # ( p3 p2 p1 -- p2 p1 p3 ) STACK: rotate p3 to be NOSTOS
# -----------------------------------------------------------------------------

  
  lw t4, 16(s4)  # p3 
  lw t3, 12(s4)

  lw t2,  8(s4)  # p2 
  lw t1,  4(s4)

  lw t0,  0(s4)  # p1 
  #  s3 has other


  sw t1 , 12(s4) # p2 
  sw t2 , 16(s4)

  sw s3 , 4(s4)  # p1 
  sw t0 , 8(s4)

  mv s3 , t3     # p3 
  sw t4 , 0(s4)

  NEXT
