# SPDX-License-Identifier: GPL-3.0-only
/*
WORD:  vhere
STACK: ( -- n )
MOTIF: 
CATEG: memory 
STDID: 
SHORT: leave the value of the variable pointer VP on the stack
*/

COLON "vhere", VHERE
  .word XT_VP
  .word XT_EXIT
