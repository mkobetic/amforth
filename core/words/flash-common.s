# SPDX-License-Identifier: GPL-3.0-only
/*	Common aspects of flash support, relied on by the core.
	Expected to be supported by all MCUs.
*/

CONSTANT  "flash.page"  , FLASH_PAGE , flash_page
END FLASH_PAGE
CONSTANT  "flash.cell"  , FLASH_CELL , flash_cell
END FLASH_CELL
CONSTANT  "flash.erased"  , FLASH_ERASED , flash_erased
END FLASH_ERASED
CONSTANT "dp0.flash"   , DP0_FLASH  , dp0.flash
END DP0_FLASH
CONSTANT "flash.start" , FLASH_START  , flash.start
END FLASH_MAX
CONSTANT "flash.low"    , FLASH_LOW   , flash.low
END FLASH_LOW
CONSTANT "flash.max"    , FLASH_MAX  , flash.max
END FLASH_MAX

DEFER "flash.erase", FLASH_ERASE, XT_FAUXERASE /* ( addr -- ) erase flash page at addr */
END FLASH_ERASE

NONAME FAUXERASE /* ( addr -- ) erase (fake) flash page at addr */
    .word XT_DUP, XT_FLASH_PAGE, XT_PLUS, XT_SWAP, XT_DODO
1:	
		.word XT_FLASH_ERASED, XT_I, XT_STORE
	.word XT_DOLITERAL, 4, XT_DOPLUSLOOP, 1b
	.word XT_EXIT
END FAUXERASE

.ifdef FLUSH_REQUIRED

NONAME DOFLUSH 
	.word XT_MEMMODE
	.word XT_DOCONDBRANCH,FLASHDOTFLUSH_0001 /* if */
    .word XT_DP_CACHE
#   .word XT_DUP , XT_HEXDOT , XT_CR 
    .word XT_DOCONDBRANCH,FLASHDOTFLUSH_0001 /* if */
	.word XT_FLASH_CACHE
	.word XT_DP_CACHE
	.word XT_PLUS
	.word XT_FLASH_CELL
	.word XT_DP_CACHE
	.word XT_MINUS
	.word XT_DUP
	.word XT_TO_R
	.word XT_ZERO
	.word XT_FILL
	.word XT_R_FROM
	.word XT_DALLOT
FLASHDOTFLUSH_0001: /* then */
	.word XT_EXIT
END DOFLUSH

.endif

COLON "flush", FLUSH /* ( -- ) force flush (write) of flash.cache */
.ifdef FLUSH_REQUIRED
    .word XT_DOFLUSH
.endif
    .word XT_EXIT
END FLUSH

#COLON "flash.flush", FLASHDOTFLUSH /* ( -- ) force flush (write) of flash.cache */
NONAME FLASHDOTFLUSH                /* ( -- ) force flush (write) of flash.cache */
.ifdef FLUSH_REQUIRED
    .word XT_DOFLUSH 
.endif
    .word XT_EXIT
END FLASHDOTFLUSH
