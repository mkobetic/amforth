# SPDX-License-Identifier: GPL-3.0-only

IMMED "then", THEN
# ( -- ) FLOW: close of if...else...then 
    .word XT_GRESOLVE
    .word XT_EXIT
