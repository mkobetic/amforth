# SPDX-License-Identifier: GPL-3.0-only

IMMED "\\", BACKSLASH

    .word XT_SOURCE
    .word XT_NIP
    .word XT_TO_IN
    .word XT_STORE
    .word XT_EXIT

IMMED "\\\x23", BACKSLASHHASH

    .word XT_SOURCE
    .word XT_NIP
    .word XT_TO_IN
    .word XT_STORE
    .word XT_EXIT
            
