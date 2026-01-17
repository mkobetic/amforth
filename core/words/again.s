# SPDX-License-Identifier: GPL-3.0-only

IMMED "again", AGAIN
# ( -- ) FLOW: end of a begin...again loop
    .word XT_COMPILE
    .word XT_DOBRANCH
    .word XT_LRESOLVE
    .word XT_EXIT
