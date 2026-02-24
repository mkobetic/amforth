# SPDX-License-Identifier: GPL-3.0-only

COLON "defer", DEFER
# ( "name" -- ) create deferred word "name"
    .word XT_FLAGDOTDEFER
    .word XT_FLAGDOTPRIVATEQ
    .word XT_OR
    .word XT_DOTO
    .word XT_FLAGDOTHEADER
    .word XT_DOCREATE
    .word XT_REVEAL
    .word XT_COMPILE
    .word PFA_DODEFER
    .word XT_ZERO
    .word XT_RAMHEREPLUSPLUS
    .word XT_LBRACKET
    .word XT_FLASHDOTFLUSH
    .word XT_EXIT

COLON "defer~", CLOAKED_DEFER
# ( "name" -- ) create cloaked deferred word "name"
    .word XT_FLAGDOTVALUE
    .word XT_FLAGDOTPRIVATE
    .word XT_OR
    .word XT_DOTO
    .word XT_FLAGDOTHEADER
    .word XT_DOCREATE
    .word XT_REVEAL
    .word XT_COMPILE
    .word PFA_DODEFER
    .word XT_ZERO
    .word XT_RAMHEREPLUSPLUS
    .word XT_LBRACKET
    .word XT_FLASHDOTFLUSH
    .word XT_EXIT


