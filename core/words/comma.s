# SPDX-License-Identifier: GPL-3.0-only

DEFER "(,)", LPARENCOMMARPAREN , XT_NOP  

COLON ",", COMMA 
    .word XT_MEMMODE
    .word XT_DOCONDBRANCH,COMMA_0001 /* if */
    .word XT_LPARENCOMMARPAREN
    .word XT_DOBRANCH,COMMA_0002
COMMA_0001: # else
    .word XT_DP
    .word XT_STORE
    .word XT_CELL
    .word XT_DALLOT
COMMA_0002: # then
    .word XT_EXIT

