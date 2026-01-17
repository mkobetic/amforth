# SPDX-License-Identifier: GPL-3.0-only

IMMED "\x3b", SEMICOLON
    .word XT_COMPILE
    .word XT_EXIT
    .word XT_LBRACKET
    .word XT_REVEAL
# addition for EOW marker     # removed but left for reference 
#    .word XT_DOLITERAL
#    .word 0xE339E339
#    .word XT_COMMA
# end addition
#    .word XT_TOFLUSH  # this may be the correct place !!!
    .word XT_EXIT


