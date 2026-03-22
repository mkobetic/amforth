# SPDX-License-Identifier: GPL-3.0-only

COLON "defer", DEFER /* ( "name" -- ) create deferred word "name" */
    .word XT_FLAGDOTDEFER
    .word XT_DOTO
    .word XT_FLAGDOTHEADER
    .word XT_TPILE_WORD
    .word XT_DOCREATE
    .word XT_REVEAL
    .word XT_COMPILE
    .word PFA_DODEFER
    .word XT_ZERO
    .word XT_RAMCOMMA
    .word XT_LBRACKET
    .word XT_FLASHDOTFLUSH
    .word XT_TPILE_END
    .word XT_EXIT
END DEFER


