# SPDX-License-Identifier: GPL-3.0-only

IMMED "repeat", REPEAT
# ( -- ) FLOW: end of a begin...while...repeat loop
    .word XT_AGAIN
    .word XT_THEN
    .word XT_EXIT
