# SPDX-License-Identifier: GPL-3.0-only

IMMED "+loop", PLUSLOOP
# ( n -- ) FLOW: increment do loop counter by n 
    .word XT_COMPILE
    .word XT_DOPLUSLOOP
    .word XT_ENDLOOP
    .word XT_EXIT
