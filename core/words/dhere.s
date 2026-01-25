# SPDX-License-Identifier: GPL-3.0-only
/*
WORD:  dhere
STACK: ( -- n )
MOTIF: 
CATEG: memory 
STDID: 
SHORT: leave the value of the dictionary pointer DP on the stack
*/

COLON "dhere", DHERE
  .word XT_DP
  .word XT_EXIT
