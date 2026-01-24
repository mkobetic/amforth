# SPDX-License-Identifier: GPL-3.0-only
CONSTANT "dp0.ram" , DP0DOTRAM , dp0.ram 

CONSTANT "vp0"    , VP0      , vp0
CONSTANT "vp.max" , VPDOTMAX , vp.max
VALUE    "vp"     , VP       , vp0 

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

