# SPDX-License-Identifier: GPL-3.0-only

COLON ":noname", COLONNONAME
    .word XT_DP
    .word XT_DUP
    .word XT_LATEST
    .word XT_STORE

# this is related to the flash issue
# when XT_COMPILE is over a page boundary 
.ifnb ORIGINAL
    .word XT_COMPILE
    .word DOCOLON
.else
    .word XT_CON_COLON
    .word XT_COMMA
.endif     

    .word XT_RBRACKET
    .word XT_EXIT

