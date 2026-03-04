# SPDX-License-Identifier: GPL-3.0-only

IMMED "sliteral", SLITERAL /* (C: s -- ) compile code that will append s as a literal to the dictionary */
    .word XT_COMPILE
    .word XT_DOSLITERAL
    .word XT_SCOMMA
    .word XT_EXIT
END SLITERAL
