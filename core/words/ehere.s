# SPDX-License-Identifier: GPL-3.0-only
/*
WORD:  ehere
STACK: ( -- n )
MOTIF: 
CATEG: memory 
STDID: 
SHORT: leave the value of the eeprom pointer EP on the stack
*/

COLON "ehere", EHERE
  .word XT_EP
  .word XT_EXIT
