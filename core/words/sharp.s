# SPDX-License-Identifier: GPL-3.0-only

COLON "<#", L_SHARP
# ( NA ) OUTPUT: NA

    .word XT_PAD, XT_HLD, XT_STORE
    .word XT_EXIT

COLON "#", SHARP
# ( NA ) OUTPUT: NA

    .word XT_BASE, XT_FETCH
    .word XT_ZERO
    .word XT_UDSLASHMOD
    .word XT_ROT
    .word XT_DROP
    .word XT_ROT
    .word XT_DOLITERAL, 9
    .word XT_OVER, XT_LESS
    .word XT_DOCONDBRANCH, PFA_SHARP1
    .word XT_DOLITERAL, 7, XT_PLUS
PFA_SHARP1:
    .word XT_DOLITERAL, 48, XT_PLUS
    .word XT_HOLD, XT_EXIT

COLON "#s", SHARP_S
# ( NA ) OUTPUT: NA
    .word XT_SHARP, XT_2DUP, XT_OR
    .word XT_ZEROEQUAL, XT_DOCONDBRANCH, PFA_SHARP_S
    .word XT_EXIT

COLON "#>", SHARP_G
# ( NA ) OUTPUT: NA
    .word XT_2DROP, XT_HLD, XT_FETCH
    .word XT_PAD, XT_OVER, XT_MINUS
    .word XT_EXIT
