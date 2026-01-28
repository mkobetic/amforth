# SPDX-License-Identifier: GPL-3.0-only
/*
WORD:  evaluate
STACK: ( a u -- )
MOTIF: 
CATEG: compiler
STDID: core/EVALUATE
SHORT: interpret a Forth string of length u starting at address a 
*/

VARIABLE "evaluate.strlen",EVALUATEDOTSTRLEN
VARIABLE "evaluate.str",EVALUATEDOTSTR
# ----------------------------------------------------------------------
COLON "evalulate.source"  , SOURCEMINUSSTRING 
    .word XT_EVALUATEDOTSTR
    .word XT_FETCH
    .word XT_EVALUATEDOTSTRLEN
    .word XT_FETCH
    .word XT_EXIT
# ----------------------------------------------------------------------
COLON "(evaluate)" LPARENEVALUATERPAREN 
    .word XT_DOLITERAL
    .word XT_SOURCE
    .word XT_DEFER_FETCH
    .word XT_TO_R
    .word XT_TO_IN
    .word XT_FETCH
    .word XT_TO_R
    .word XT_ZERO
    .word XT_TO_IN
    .word XT_STORE
    .word XT_EVALUATEDOTSTRLEN
    .word XT_STORE
    .word XT_EVALUATEDOTSTR
    .word XT_STORE
    .word XT_DOLITERAL
    .word XT_SOURCEMINUSSTRING
    .word XT_DOTO
    .word XT_SOURCE
    .word XT_DOLITERAL
    .word XT_INTERPRET
    .word XT_CATCH
    .word XT_R_FROM
    .word XT_TO_IN
    .word XT_STORE
    .word XT_R_FROM
    .word XT_DOTO
    .word XT_SOURCE
    .word XT_THROW
    .word XT_EXIT
# ----------------------------------------------------------------------
IMMED "evaluate", EVALUATE 
    .word XT_STATE
    .word XT_FETCH
    .word XT_DOCONDBRANCH,EVALUATE_0001 /* if */
    .word XT_COMPILE
    .word XT_LPARENEVALUATERPAREN
    .word XT_DOBRANCH,EVALUATE_0002
EVALUATE_0001: /* else */
    .word XT_LPARENEVALUATERPAREN
EVALUATE_0002: /* then */
    .word XT_EXIT
