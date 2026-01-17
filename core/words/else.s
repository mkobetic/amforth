# SPDX-License-Identifier: GPL-3.0-only

IMMED "else", ELSE
# ( -- ) FLOW: if f of if t then do body of else 

    .word XT_COMPILE
    .word XT_DOBRANCH
    .word XT_GMARK
    .word XT_SWAP
    .word XT_GRESOLVE
    .word XT_EXIT
