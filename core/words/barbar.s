# SPDX-License-Identifier: GPL-3.0-only
VARIABLE "debug" , DEBUG 

# : || debug @ 0= if postpone \ then ; immediate 

IMMED "||", BARBAR 
    .word XT_DEBUG
    .word XT_FETCH
    .word XT_ZEROEQUAL
    .word XT_DOCONDBRANCH , BARBAR1 
    .word XT_BACKSLASH
BARBAR1:    
    .word XT_EXIT
