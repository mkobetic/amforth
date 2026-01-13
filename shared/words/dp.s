
VALUE "dp", DP, dp0.ram

COLON "dp-allot", DPALLOT
    .word XT_DP
    .word XT_PLUS
    .word XT_DOTO, XT_DP
    .word XT_EXIT
