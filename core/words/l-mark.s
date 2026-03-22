# SPDX-License-Identifier: GPL-3.0-only

NONAME "<mark", LMARK /* ( -- addr ) remember dp as address of a backward jump */
    .word XT_DP
    .word XT_TPILE_LABEL
    .word XT_EXIT
END LMARK
