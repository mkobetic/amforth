# SPDX-License-Identifier: GPL-3.0-only

IMMED "match" , MATCH # ( x -- x ) MATCH: test value x for match..act..end..endmatch
    .word XT_ZERO
    .word XT_EXIT 


IMMED "act" , ACT # ( x test-xt -- NUL|x ) MATCH: apply test ( x -- f ) if f is t then do body   
    .word XT_1PLUS
    .word XT_TO_R
    .word XT_COMPILE , XT_OVER 
    .word XT_COMPILE , XT_SWAP
    .word XT_COMPILE , XT_EXECUTE
    .word XT_DOXLITERAL , XT_IF
    .word XT_EXECUTE 
    .word XT_COMPILE , XT_DROP
    .word XT_R_FROM
    .word XT_EXIT 


IMMED "end" , END # ( -- ) MATCH: close for act in match..act..end..endmatch
     .word XT_TO_R 
     .word XT_DOXLITERAL , XT_ELSE , XT_EXECUTE 
     .word XT_R_FROM  
     .word XT_EXIT


IMMED "endmatch" , ENDMATCH # ( x -- ) MATCH: close for match in match..act..end..endmatch
     .word XT_COMPILE , XT_DROP
     .word XT_ZERO , XT_DODO
ENDMATCH1:
     .word XT_DOXLITERAL , XT_THEN , XT_EXECUTE, XT_DOLOOP , ENDMATCH1
     .word XT_EXIT

