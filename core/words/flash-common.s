# SPDX-License-Identifier: GPL-3.0-only
/*	Common aspects of flash support, relied on by the core.
	Expected to be supported by all MCUs.
*/

CONSTANT  "flash.page"  , FLASHDOTPAGE , flash_page
END FLASHDOTPAGE
CONSTANT  "flash.cell"  , FLASHDOTCELL , flash_cell
END FLASHDOTCELL
CONSTANT  "flash.erased"  , FLASHDOTERASED , flash_erased
END FLASHDOTERASED
CONSTANT "dp0.flash"   , DP0DOTFLASH  , dp0.flash
END DP0DOTFLASH
CONSTANT "flash.max"    , FLASH_MAX  , flash.max
END FLASH_MAX

.ifdef FLUSH_REQUIRED

NONAME LBRAFLUSHRBRA 
	.word XT_MEMMODE
	.word XT_DOCONDBRANCH,FLASHDOTFLUSH_0001 /* if */
    .word XT_DPDOTCACHE
#   .word XT_DUP , XT_HEXDOT , XT_CR 
    .word XT_DOCONDBRANCH,FLASHDOTFLUSH_0001 /* if */
	.word XT_FLASHDOTCACHE
	.word XT_DPDOTCACHE
	.word XT_PLUS
	.word XT_FLASHDOTCELL
	.word XT_DPDOTCACHE
	.word XT_MINUS
	.word XT_DUP
	.word XT_TO_R
	.word XT_ZERO
	.word XT_FILL
	.word XT_R_FROM
	.word XT_DALLOT
FLASHDOTFLUSH_0001: /* then */
	.word XT_EXIT
END LBRAFLUSHRBRA

.endif

COLON "flush", FLUSH /* ( -- ) force flush (write) of flash.cache */
.ifdef FLUSH_REQUIRED
    .word XT_LBRAFLUSHRBRA
.endif
    .word XT_EXIT
END FLUSH

#COLON "flash.flush", FLASHDOTFLUSH /* ( -- ) force flush (write) of flash.cache */
NONAME FLASHDOTFLUSH                /* ( -- ) force flush (write) of flash.cache */
.ifdef FLUSH_REQUIRED
    .word XT_LBRAFLUSHRBRA 
.endif
    .word XT_EXIT
END FLASHDOTFLUSH
