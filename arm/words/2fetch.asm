# SPDX-License-Identifier: GPL-3.0-only
/*
WORD:  2@
STACK: ( a -- x1 x2 )
MOTIF: 
CATEG: double 
STDIN: core/TwoFetch
SHORT: Fetch cell pair x1 x2 stored at a x2 is stored at a and x1 at the next consecutive cell.
*/

@------------------------------------------------------------------------------
  CODEWORD  "2@",2FETCH @ Fetch ( addr -- d )
@------------------------------------------------------------------------------
  subs psp, #4
  ldr r0, [tos, #4]
  str r0, [psp]
  ldr tos, [tos]
NEXT
