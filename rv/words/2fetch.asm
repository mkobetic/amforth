# SPDX-License-Identifier: GPL-3.0-only
/*
WORD:  2@
STACK: ( a -- x1 x2 )
MOTIF: 
CATEG: double 
STDIN: core/TwoFetch
SHORT: Fetch cell pair x1 x2 stored at a x2 is stored at a and x1 at the next consecutive cell.
*/

#------------------------------------------------------------------------------
  CODEWORD  "2@",2FETCH # Fetch ( addr -- d )
#------------------------------------------------------------------------------
  addi s4, s4, -4
  lw   t0, 4(s3)
  sw   t0, 0(s4)
  lw   s3, 0(s3)
NEXT
