# SPDX-License-Identifier: GPL-3.0-only
CONSTANT "dp0.ram" , DP0DOTRAM , dp0.ram 

CONSTANT "vp0"    , VP0      , vp0
CONSTANT "vp.max" , VPDOTMAX , vp.max
VALUE    "vp"     , VP       , vp0 

COLON "vallot" , VALLOT
# ( n -- ) MEMORY: allocate n bytes in variable space (RAM)

    .word XT_VP
    .word XT_PLUS
    .word XT_DOTO, XT_VP

    .word XT_VP
    .word XT_VPDOTMAX
    .word XT_LESS , XT_DOCONDBRANCH, VALLOT_0000
    .word XT_FINISH
VALLOT_0000:
    STRING "ram pool overwrites ram dictionary"
    .word XT_TYPE
    .word XT_DOLITERAL
    .word -50
    .word XT_THROW
    .word XT_EXIT 


COLON "ram", RAMHERE
# ( -- a ) MEMORY: current value of ram pool pointer 
      .word XT_VP
      .word XT_EXIT      

COLON "ram+", RAMHEREPLUS
# ( -- a ) MEMORY: current value of ram pool pointer, increment
    .word XT_VP
    .word XT_ONE
    .word XT_VALLOT
    .word XT_EXIT

COLON "ram++", RAMHEREPLUSPLUS
# ( -- a ) MEMORY:
    .word XT_VP
    .word XT_CELL
    .word XT_VALLOT
    .word XT_EXIT

