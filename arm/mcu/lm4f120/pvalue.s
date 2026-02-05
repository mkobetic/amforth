PVALUE "pvtest", PVTEST, 42
END PVTEST

DEFER "!df", STORE_DF, XT_STORE /* (x addr -- ) store x at addr in the data flash */
END STORE_DF

DEFER "@df", FETCH_DF, XT_FETCH /* (addr -- x) load cell at addr in the data flash */
END FETCH_DF

/* TODO: this will be replaced by pvstore.df once it's transpiled */
DEFER "pvstore", PVSTORE, XT_STORE /* ( x addr -- ) update pvalue with RAM address addr to value x */
END PVSTORE

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
