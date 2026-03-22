# SPDX-License-Identifier: GPL-3.0-only

COLON "constant", CONSTANT /* ( -- x )(C: x "name" -- ) create constant "name" with value x */
    .word XT_FLAGDOTCON
    .word XT_DOTO
    .word XT_FLAGDOTHEADER
    .word XT_TPILE_WORD
    .word XT_DOCREATE
    .word XT_REVEAL
    .word XT_COMPILE
    .word PFA_DOVARIABLE
    .word XT_TPILE_LIT
    .word XT_COMMA
    .word XT_LBRACKET
    .word XT_FLASHDOTFLUSH
    .word XT_TPILE_END
    .word XT_EXIT
END CONSTANT
