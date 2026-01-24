# SPDX-License-Identifier: GPL-3.0-only
/*
WORD:  vallot
STACK: ( n -- ) 
MOTIF: 
CATEG: memory 
STDID: 
SHORT: Allocate n bytes from the variable memory pool in RAM
*/


COLON "vallot" , VALLOT
    .word XT_VP
    .word XT_PLUS
    .word XT_DOTO, XT_VP

    .word XT_VP
    .word XT_VPDOTMAX
    .word XT_LESS , XT_DOCONDBRANCH, VALLOT_0000
    .word XT_FINISH
VALLOT_0000:
    STRING "ram pool overwrites ram dictionary"
    .word XT_TYPE
    .word XT_DOLITERAL
    .word -50
    .word XT_THROW
    .word XT_EXIT 
