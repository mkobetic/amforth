# SPDX-License-Identifier: GPL-3.0-only
/*
WORD:  2!
STACK: ( x1 x2 a -- )
MOTIF: 
CATEG: double 
STDIN: core/TwoStore
SHORT: Store cell pair x1 x2 at a, with x2 at a and x1 at the next consecutive cell.
*/

@------------------------------------------------------------------------------
  CODEWORD  "2!",2STORE @ Store ( d addr -- )
@------------------------------------------------------------------------------
  ands r0, tos, #0x3     /* cell aligned?         */
  beq  1f                /* branch if OK          */
  throw EADRINV          /* not aligned so throw  */
1:                       /* normal operation      */
  ldmia psp!, {r1, r2}
  str r1, [tos]
  str r2, [tos, #4]
  ldm psp!, {tos}
NEXT
