# SPDX-License-Identifier: GPL-3.0-only

COLON "value", VALUE /* ( x "name" -- ) create value "name" with initial of x */
    .word XT_FLAGDOTVALUE
    .word XT_DOTO
    .word XT_FLAGDOTHEADER
    .word XT_TPILE_WORD
    .word XT_DOCREATE
    .word XT_REVEAL
    .word XT_COMPILE
    .word PFA_DOVALUE
    .word XT_TPILE_LIT
    .word XT_RAMCOMMA
    # added 
    .word XT_LBRACKET
    .word XT_FLASHDOTFLUSH
    # end added
    .word XT_TPILE_END
    .word XT_EXIT
END VALUE

