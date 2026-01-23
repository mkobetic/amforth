# SPDX-License-Identifier: GPL-3.0-only
/*
WORD:  2!
STACK: ( x1 x2 a -- )
MOTIF: 
CATEG: double 
STDIN: core/TwoStore
SHORT: Store cell pair x1 x2 at a, with x2 at a and x1 at the next consecutive cell.
*/
            
#------------------------------------------------------------------------------
  CODEWORD  "2!",2STORE # Store ( d addr -- )
#------------------------------------------------------------------------------
  lw t0, 0(s4)
  lw t1, 4(s4)
  addi s4, s4, 8
  sw t0, 0(s3)	
  sw t1, 4(s3)	
  lw s3, 0(s4)
  addi s4, s4, 4
NEXT
