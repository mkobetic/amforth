# SPDX-License-Identifier: GPL-3.0-only
# MFD VALUE "header.flag" , HEADERDOTFLAG, 0x33

COLON "header", HEADER

    .word XT_OVER,XT_GREATERZERO 
    .word XT_DOCONDBRANCH, PFA_HEADER1
    .word XT_EXECUTE
    .word XT_COMMA
    .word XT_DP,XT_TO_R
# original
#    .word XT_DOLITERAL
#    .word Flag_visible
# new
    .word XT_FLAGDOTHEADER
    .word XT_COMMA
    .word XT_SCOMMA
    .word XT_R_FROM
    .word XT_EXIT

PFA_HEADER1:
    .word XT_DOLITERAL
    .word -16
    .word XT_THROW
