# SPDX-License-Identifier: GPL-3.0-only

/*
WORD:  ealign
STACK: ( -- ) 
MOTIF: 
CATEG: memory
STDID: 
SHORT: Align dictionary pointer to cell boundary in EEPROM
*/

COLON "ealign" , EALIGN
    .word XT_EP
    .word XT_ALIGNED
    .word XT_EP
    .word XT_MINUS
    .word XT_EALLOT    
    .word XT_EXIT

