# SPDX-License-Identifier: GPL-3.0-only

COLON "dalign" , DALIGN /* ( -- ) align dictionary pointer to cell boundary in RAM or flash */
    .word XT_DP
    .word XT_ALIGNED
    .word XT_DP
    .word XT_MINUS
    .word XT_DALLOT    
    .word XT_EXIT
END DALIGN
