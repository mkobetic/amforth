NONAME DODALLOT 
	.word XT_DP
	.word XT_PLUS
    .word XT_DOTO
	.word XT_DP
	.word XT_EXIT
END DODALLOT

NONAME DOCCOMMA 
	.word XT_DP
	.word XT_CSTORE
	.word XT_ONE
	.word XT_DALLOT
	.word XT_EXIT
END DOCCOMMA

NONAME DOCOMMA 
	.word XT_DP
	.word XT_STORE
	.word XT_CELL
	.word XT_DALLOT
	.word XT_EXIT
END DOCOMMA

NONAME STORE_I
	.word XT_STORE, XT_EXIT
END STORE_I

COLON "flash.erase", FLASH_ERASE /* ( addr -- ) erase (fake) flash page at addr */
    .word XT_DUP, XT_FLASH_PAGE, XT_PLUS, XT_SWAP, XT_DODO
1:	
		.word XT_FLASH_ERASED, XT_I, XT_STORE
	.word XT_DOLITERAL, 4, XT_DOPLUSLOOP, 1b
	.word XT_EXIT
END FLASH_ERASE
