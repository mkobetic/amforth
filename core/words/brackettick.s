# SPDX-License-Identifier: GPL-3.0-only

IMMED "[\x27]" BRACKETTICK
# ( "name" -- xt ) FLOW: leave xt of "name" (in colon defn)
    .word XT_TICK
#    .word XT_LITERAL   # replaced by below so that save can find xt as literal
    # and translate the address (from RAM dict to FLASH dict) 
    .word XT_XLITERAL   
    .word XT_EXIT
