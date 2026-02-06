/* following deferred words are data flash primitives that need to be implemented by the MCU */

DEFER "!df", STORE_DF, XT_STORE /* (x addr -- ) store x at addr in the data flash */
END STORE_DF

DEFER "@df", FETCH_DF, XT_FETCH /* (addr -- x) load cell at addr in the data flash */
END FETCH_DF

DEFER "df.erase", DF_ERASE, XT_FAUXERASE /* ( addr -- ) erase data flash page at addr */
END FETCH_DF

NONAME FAUXERASE /* :noname pvpgsize $FF fill ; */
    .word XT_PVPGSIZE, XT_FF, XT_FILL, XT_EXIT
END FAUXERASE

/* this is just a hack to avoid XT_DOLITERAL, 0xFF in FAUXERASE
 because it's insanely complicated to step through */
CONSTANT "ff", FF, 0xFF 

/* pvalue memory constants */

CONSTANT "pvarena1", PVARENA1, pvarena1_lower /* ( -- addr ) address of pvalue arena 1  */
END PVARENA1

CONSTANT "pvarena2", PVARENA2, pvarena2_lower /* ( -- addr ) address of pvalue arena 2  */
END PVARENA2

CONSTANT "pvasize", PVASIZE, pvarena.size /* ( -- u ) size of pvalue arena (multiple of flash page size) */
END PVASIZE

CONSTANT "pvpgsize", PVPGSIZE, pvflash.page /* ( -- u ) size of arena page (flash page size) */
END PVPGSIZE

/* pvalue runtime values, must be initialized by pv.init */

VALUE "pvp", PVP, 0 /* ( -- addr ) address of the next free cell in active arena */
END PVP

VALUE "pvarena", PVARENA, 0 /* ( -- addr ) start address of active arena */
END PVARENA

/* test pvalues */
PVALUE "pv1", PV1, 42
PVALUE "pv2", PV2, 42
PVALUE "pv3", PV3, 42
