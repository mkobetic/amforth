# SPDX-License-Identifier: GPL-3.0-only

DEFER ".ready", PROMPTREADY, XT_PROMPTREADYDEFAULT

NONAME PROMPTREADYDEFAULT

    .word XT_CR
    STRING "> "
    .word XT_TYPE
    .word XT_EXIT
