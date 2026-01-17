# SPDX-License-Identifier: GPL-3.0-only

IMMED "if", IF
# ( f -- ) FLOW: if f true do body of if 
    .word XT_COMPILE
    .word XT_DOCONDBRANCH
    .word XT_GMARK
    .word XT_EXIT
