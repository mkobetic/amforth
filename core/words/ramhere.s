# SPDX-License-Identifier: GPL-3.0-only

CONSTANT "vp0"    , VP0      , vp0 /* start of the RAM pool */
END VP0
CONSTANT "vp.max" , VPDOTMAX , vp.max /* end of the RAM pool */
END VPDOTMAX
VALUE    "vp"     , VP       , vp0 /* RAM pool pointer */
END VP

COLON "ram", RAMHERE /* ( -- a ) current value of ram pool pointer */
      .word XT_VP
      .word XT_EXIT      
END RAMHERE

COLON "ram+", RAMHEREPLUS /* ( -- a ) increment ram pool pointer by 1 byte */
    .word XT_VP
    .word XT_ONE
    .word XT_VALLOT
    .word XT_EXIT
END RAMHEREPLUS

COLON "ram++", RAMHEREPLUSPLUS /* ( -- a ) increment ram pool pointer by 1 cell */
# ( -- a ) MEMORY:
    .word XT_VP
    .word XT_CELL
    .word XT_VALLOT
    .word XT_EXIT
END RAMHEREPLUSPLUS
