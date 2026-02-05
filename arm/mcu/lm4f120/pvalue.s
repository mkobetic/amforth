
DEFER "!df", STORE_DF, XT_STORE /* (x addr -- ) store x at addr in the data flash */
END STORE_DF

DEFER "@df", FETCH_DF, XT_FETCH /* (addr -- x) load cell at addr in the data flash */
END FETCH_DF

CONSTANT "pvarena1", PVARENA1, pvarena1_lower /* ( -- addr ) address of pvalue arena 1  */
END PVARENA1

CONSTANT "pvarena2", PVARENA2, pvarena1_lower /* ( -- addr ) address of pvalue arena 2  */
END PVARENA2

CONSTANT "pvasize", PVASIZE, pvasize /* ( -- u ) size of a pvalue arena */
END PVASIZE

VALUE "pvp", PVP, pvarena1_lower /* ( -- addr ) address of the next free cell in active arena */
END PVP

VALUE "pvarena", PVARENA, pvarena1_lower /* ( -- addr ) start address of active arena */
END PVARENA

/* TODO: These are just for testing at the interpreter level and won't work in compilation mode.
    ITC will want to call PVSTORE with hardcoded pointers to predefined flash values.
 */
@ COLON "pvto", PVTO /* ( x "name" -- ) set pvalue to x */
@     .word XT_PVADDR
@     .word XT_PVSTORE
@     .word XT_EXIT
@ END PVTO

@ COLON "pvaddr", PVADDR /* ( "name" -- addr ) RAM address of pvalue "name" */
@     .word XT_TICK
@     .word XT_TO_BODY
@     .word XT_FETCH
@     .word XT_EXIT
@ END PVADDR
