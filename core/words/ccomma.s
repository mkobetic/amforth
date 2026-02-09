
DEFER "(c,)", LPARENCCOMMARPAREN, XT_NOP
END LPARENCCOMMARPAREN

COLON "c,", CCOMMA /* ( c -- ) append c to the dictionary */
    .word XT_MEMMODE
    .word XT_DOCONDBRANCH,CCOMMA_0001 /* if */
    .word XT_LPARENCCOMMARPAREN
    .word XT_DOBRANCH,CCOMMA_0002
CCOMMA_0001: # else
    .word XT_DP
    .word XT_CSTORE
    .word XT_ONE
    .word XT_DALLOT
CCOMMA_0002: # then
    .word XT_EXIT
END CCOMMA
