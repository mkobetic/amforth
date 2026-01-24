# SPDX-License-Identifier: GPL-3.0-only

/*
WORD:  dalign
STACK: ( -- ) 
MOTIF: 
CATEG: memory
STDID: 
SHORT: Align dictionary pointer to cell boundary in RAM or flash
*/

COLON "dalign" , DALIGN
    .word XT_DP
    .word XT_ALIGNED
    .word XT_DP
    .word XT_MINUS
    .word XT_DALLOT    
    .word XT_EXIT

