
COLON ",", COMMA

    .word XT_DP
    .word XT_STORE
    .word XT_DP
    .word XT_DOLITERAL,4
    .word XT_DPALLOT
    .word XT_EXIT

COLON "c,", CCOMMA
   .word XT_DP
   .word XT_CSTORE
   .word XT_ONE, XT_DPALLOT
   .word XT_EXIT
