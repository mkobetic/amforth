# SPDX-License-Identifier: GPL-3.0-only

DEFER "source", SOURCE, XT_SOURCETIB

COLON "source-tib", SOURCETIB

    .word XT_TIB
    .word XT_NUMBERTIB
    .word XT_FETCH
    .word XT_EXIT
