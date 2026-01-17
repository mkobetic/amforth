# SPDX-License-Identifier: GPL-3.0-only

IMMED "until", UNTIL
# ( f -- ) FLOW: if f t then leave begin...until loop 
    .word XT_DOLITERAL
    .word XT_DOCONDBRANCH
    .word XT_COMMA

    .word XT_LRESOLVE
    .word XT_EXIT
