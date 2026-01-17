# SPDX-License-Identifier: GPL-3.0-only
#HEADLESS DODEFER
HIDEWORD "(DODEFER)" , DODEFER
  lw s1,0(s1)
  lw s1,0(s1)
  j DO_EXECUTE
  NEXT 

CODEWORD "odd" , ODD

  lw s1,0(s1)
  j DO_EXECUTE

  NEXT

CONSTANT "pfa.odd", PFADOTODD , PFA_ODD 
