# SPDX-License-Identifier: GPL-3.0-only

COLON "dallot", DALLOT
# ( n -- ) MEMORY: Allocate n bytes from RAM 
     .word XT_DP
     .word XT_TUCK
     .word XT_PLUS
     .word XT_DOTO, XT_DP

     .word XT_MEMMODE 
     .word XT_DOCONDBRANCH,DALLOT_0001

     .word XT_DOLITERAL
     .word 0xFFFFF000
     .word XT_AND
     
     .word XT_DP
     .word XT_DOLITERAL
     .word 0xFFFFF000
     .word XT_AND

     .word XT_MINUS
     .word XT_DOCONDBRANCH,DALLOT_0002
     .word XT_STDDOTUNLOCK
     .word XT_DP
     .word XT_STDDOTERASE
     STRING "*************************dallot:erase**********************"
     .word XT_TYPE , XT_CR
     .word XT_FINISH
DALLOT_0001:
     .word XT_DROP
DALLOT_0002:     
     .word XT_EXIT

