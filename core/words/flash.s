/* Following words are FLASH primitives that are overridden by real MCUs */

COLON "~(dallot)", TILDEDODALLOT 
	.word XT_DP
	.word XT_PLUS
    .word XT_DOTO
	.word XT_DP
	.word XT_EXIT
END TILDEDODALLOT

COLON "~(c,)", TILDEDOCCOMMA 
	.word XT_DP
	.word XT_CSTORE
	.word XT_ONE
	.word XT_DALLOT
	.word XT_EXIT
END TILDEDOCCOMMA

COLON "~(,)", TILDEDOCOMMA 
	.word XT_DP
	.word XT_STORE
	.word XT_CELL
	.word XT_DALLOT
	.word XT_EXIT
END TILDEDOCOMMA

COLON "~!i", TILDESTORE_I
	.word XT_STORE, XT_EXIT
END TILDESTORE_I

COLON "~flash.erase", TILDEFLASH_ERASE /* ( addr -- ) erase (fake) flash page at addr */
    .word XT_DUP, XT_FLASH_PAGE, XT_PLUS, XT_SWAP, XT_DODO
1:	
		.word XT_FLASH_ERASED, XT_I, XT_STORE
	.word XT_DOLITERAL, 4, XT_DOPLUSLOOP, 1b
	.word XT_EXIT
END TILDEFLASH_ERASE

/* following words are PVFLASH primitives that are overridden by real MCUs */

NONAME "~2!pvf", TILDE2STORE_PVF /* ( x1 x2 addr -- ) [addr] = x2, [addr+cellsize] = x1 (in the PV flash) */
	.word XT_2STORE, XT_EXIT
END TILDE2STORE_PVF

COLON "~pvflash.erase", TILDEPVFLASH_ERASE /* ( addr -- ) erase PV flash page at addr */
    .word XT_DUP, XT_PVFLASH_PAGE, XT_PLUS, XT_SWAP, XT_DODO
1:	
		.word XT_PVFLASH_ERASED, XT_I, XT_STORE
	.word XT_DOLITERAL, 4, XT_DOPLUSLOOP, 1b
	.word XT_EXIT
END TILDEPVFLASH_ERASE
