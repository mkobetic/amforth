# SPDX-License-Identifier: GPL-3.0-only

IMMED "begin", BEGIN
# ( -- ) FLOW: start a begin..again|repeat|until loop 
    .word XT_LMARK
    .word XT_EXIT
