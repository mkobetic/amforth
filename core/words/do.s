# SPDX-License-Identifier: GPL-3.0-only

IMMED "do", DO
    .word XT_COMPILE
    .word XT_DODO
    .word XT_LMARK
    .word XT_ZERO, XT_TO_L
    .word XT_EXIT
