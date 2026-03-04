# SPDX-License-Identifier: GPL-3.0-only

IMMED "[char]", BRACKETCHAR /* ( -- )(C: "name" -- ) compile code that will append first letter of "name" to the dictionary */
    .word XT_COMPILE
    .word XT_DOLITERAL
    .word XT_CHAR
    .word XT_COMMA
    .word XT_EXIT
END BRACKETCHAR
