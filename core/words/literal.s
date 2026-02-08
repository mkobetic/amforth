# SPDX-License-Identifier: GPL-3.0-only

IMMED "literal", LITERAL /* ( x -- ) append x as a literal to the dictionary */
        .word XT_COMPILE
        .word XT_DOLITERAL
        .word XT_COMMA
        .word XT_EXIT
END LITERAL
