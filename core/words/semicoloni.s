# SPDX-License-Identifier: GPL-3.0-only

IMMED "\x3bi", SEMICOLONI
    .word XT_COMPILE
    .word XT_EXITI
    .word XT_LBRACKET
    .word XT_REVEAL
# addition for EOW marker     
    .word XT_DOLITERAL
    .word 0xE339E339
    .word XT_COMMA
# end addition     
    .word XT_EXIT


