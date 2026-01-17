# SPDX-License-Identifier: GPL-3.0-only

IMMED "while", WHILE
# ( f -- ) FLOW: if f t then do body of while 
    .word XT_IF
    .word XT_SWAP
    .word XT_EXIT
