# SPDX-License-Identifier: GPL-3.0-only

IMMED "case" , CASE # ( x -- x ) CASE: test value x for case..of..endof..endcase
    .word XT_ZERO
    .word XT_EXIT 


IMMED "of" , OF # ( x n -- NUL|x ) CASE: if x equals n do body of..endof else leave x on stack
    .word XT_1PLUS
    .word XT_TO_R
    .word XT_COMPILE , XT_OVER 
    .word XT_COMPILE , XT_EQUAL
    .word XT_DOXLITERAL , XT_IF
    .word XT_EXECUTE 
    .word XT_COMPILE , XT_DROP
    .word XT_R_FROM
    .word XT_EXIT 


IMMED "endof" , ENDOF # ( -- ) CASE: close for of in of..endof
     .word XT_TO_R 
     .word XT_DOXLITERAL , XT_ELSE , XT_EXECUTE 
     .word XT_R_FROM  
     .word XT_EXIT


IMMED "endcase" , ENDCASE # ( x -- ) CASE: close for case in case..of..endof..endcase
     .word XT_COMPILE , XT_DROP
     .word XT_ZERO , XT_DODO
ENDCASE1:
     .word XT_DOXLITERAL , XT_THEN , XT_EXECUTE, XT_DOLOOP , ENDCASE1
     .word XT_EXIT

