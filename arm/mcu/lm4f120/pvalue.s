
DEFER "!df", STORE_DF, XT_STORE /* (x addr -- ) store x at addr in the data flash */
END STORE_DF

DEFER "@df", FETCH_DF, XT_FETCH /* (addr -- x) load cell at addr in the data flash */
END FETCH_DF

CONSTANT "pvarena1", PVARENA1, pvarena1_lower /* ( -- addr ) address of pvalue arena 1  */
END PVARENA1

CONSTANT "pvarena2", PVARENA2, pvarena2_lower /* ( -- addr ) address of pvalue arena 2  */
END PVARENA2

CONSTANT "pvasize", PVASIZE, pvasize /* ( -- u ) size of a pvalue arena */
END PVASIZE

/* must be initialized by pv.init */
VALUE "pvp", PVP, 0 /* ( -- addr ) address of the next free cell in active arena */
END PVP

/* must be initialized by pv.init */
VALUE "pvarena", PVARENA, 0 /* ( -- addr ) start address of active arena */
END PVARENA
