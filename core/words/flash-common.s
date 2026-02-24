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
CONSTANT "flash.start" , FLASH_START  , flash.start
END FLASH_MAX
CONSTANT "flash.low"    , FLASH_LOW   , flash.low
END FLASH_LOW
CONSTANT "flash.max"    , FLASH_MAX  , flash.max
END FLASH_MAX

/* flash primitives */

DEFER "(dallot)", DODALLOT, XT_TILDEDODALLOT /* ( u -- ) allocate u bytes in the dictionary */
END DODALLOT

DEFER "(,)", DOCOMMA, XT_TILDEDOCOMMA /* ( x -- ) append x to the dictionary */
END DOCOMMA

DEFER "(c,)", DOCCOMMA, XT_TILDEDOCCOMMA /* ( c -- ) append c to the dictionary */
END DOCCOMMA

DEFER "!i", STORE_I , XT_TILDESTORE_I
END STORE_I

DEFER "flash.erase", FLASH_ERASE, XT_TILDEFLASH_ERASE /* ( addr -- ) erase flash page at addr */
END FLASH_ERASE

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
