# SPDX-License-Identifier: GPL-3.0-only

/*
WORD:  valign
STACK: ( -- ) 
MOTIF: 
CATEG: memory
STDID: 
SHORT: Align dictionary pointer to cell boundary in variable memory space RAM 
*/

COLON "valign" , VALIGN
    .word XT_VP
    .word XT_ALIGNED
    .word XT_VP
    .word XT_MINUS
    .word XT_VALLOT    
    .word XT_EXIT

