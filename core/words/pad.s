# SPDX-License-Identifier: GPL-3.0-only
# old way 
#COLON "pad", PAD
#    .word XT_HERE, XT_DOLITERAL, 0x100
#    .word XT_PLUS, XT_EXIT

COLON "pad", PAD
    .word XT_DP_RAM, XT_DP , XT_UMAX
    .word XT_DOLITERAL, 0x100
    .word XT_PLUS, XT_EXIT
