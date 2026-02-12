# SPDX-License-Identifier: GPL-3.0-only

VALUE     "dp.cache"    , DP_CACHE , 0
END DP_CACHE
NVARIABLE "flash.cache" , FLASH_CACHE , flash_cell / cellsize
END FLASH_CACHE
NVARIABLE "flash.shadow" , FLASH_SHADOW , flash_cell / cellsize
END FLASH_SHADOW

#======================================================================

CODEWORD "(flash.erase)" , DOFLASH_ERASE /* ( fa -- ) erase page containing fa */ 
    ldr r3, =__flash_erase__       // Load RAM address of xxx
    orr r3, r3, #1                 // thumb bit fix 
    blx r3                         // Call it
	NEXT
END DOFLASH_ERASE

CODEWORD "(flash.write)" , DOFLASH_WRITE /* ( fa -- ) write flash.cache to flash at fa */
    ldr r3, =__flash_write__       // Load RAM address of xxx
    orr r3, r3, #1                 // thumb bit fix 
    blx r3                         // Call it
	NEXT 
END DOFLASH_WRITE

COLON "flash.write" , FLASH_WRITE /* ( fa -- ) write flash.cache to flash at fa - flash.cell */
    .word XT_FLASH_CELL
    .word XT_MINUS
    .word XT_DOFLASH_WRITE
    .word XT_EXIT
END FLASH_WRITE

#======================================================================

COLON "flash.init" , FLASH_INIT /* ( -- ) set defers for NFF */

     /* ' ~(dallot) to (dallot) */     
    .word XT_DOLITERAL
    .word XT_TILDEDODALLOT
    .word XT_DOLITERAL    
    .word XT_LPARENDALLOTRPAREN
    .word XT_CELLPLUS
	.word XT_FETCH
	.word XT_STORE

     /* ' ~(c,) to (c,) */
    .word XT_DOLITERAL
    .word XT_TILDEDOCCOMMA
    .word XT_DOLITERAL
    .word XT_LPARENCCOMMARPAREN
    .word XT_CELLPLUS
	.word XT_FETCH
	.word XT_STORE

     /* ' ~(,) to (,) */
    .word XT_DOLITERAL
    .word XT_TILDEDOCOMMA
    .word XT_DOLITERAL
    .word XT_LPARENCOMMARPAREN
    .word XT_CELLPLUS
	.word XT_FETCH
	.word XT_STORE

     /* '~!i to !i */
    .word XT_DOLITERAL
    .word XT_TILDEBANGI 
    .word XT_DOLITERAL
    .word XT_STORE_I
    .word XT_CELLPLUS
	.word XT_FETCH
	.word XT_STORE

     /* ' (flash.erase) to flash.erase */
    .word XT_DOLITERAL
    .word XT_DOFLASH_ERASE 
    .word XT_DOLITERAL
    .word XT_FLASH_ERASE
    .word XT_CELLPLUS
	.word XT_FETCH
	.word XT_STORE

    .word XT_EXIT
END FLASH_INIT

#======================================================================
# NFF defer targets ( the words that do the work ) 

COLON "callot" , CALLOT
     .word XT_DP_CACHE
     .word XT_PLUS
     .word XT_DOTO
     .word XT_DP_CACHE
     .word XT_EXIT
END CALLOT
     
COLON "~(c,)", TILDEDOCCOMMA 
	.word XT_FLASH_CACHE
	.word XT_DP_CACHE
	.word XT_PLUS
	.word XT_CSTORE
    .word XT_ONE
    .word XT_DALLOT
	.word XT_EXIT
END TILDEDOCCOMMA

COLON "~(,)",  TILDEDOCOMMA 
	.word XT_FLASH_CACHE
	.word XT_DP_CACHE
	.word XT_PLUS
	.word XT_STORE
	.word XT_CELL
	.word XT_DALLOT
	.word XT_EXIT
END TILDEDOCOMMA

COLON "~!i", TILDEBANGI /* ( x addr -- ) write x at addr in flash */
	/* don't allow writing below dp0.flash */
	.word XT_DUP
	.word XT_DP0_FLASH
	.word XT_LESS
	.word XT_DOCONDBRANCH,TILDEBANGI_0001 /* # if */
	.word XT_DOLITERAL
	.word -10    /* replace with more suitable value */
	.word XT_THROW
TILDEBANGI_0001: /* # then */
	.word XT_FLASH_CACHE
	.word XT_FLASH_SHADOW
	.word XT_FLASH_CELL
	.word XT_MOVE
	.word XT_TO_R
	.word XT_FLASH_CACHE
	.word XT_STORE
	.word XT_DOLITERAL
    .word XT_NOP
	.word XT_FLASH_CACHE
	.word XT_CELLPLUS
	.word XT_STORE
	.word XT_R_FROM
	.word XT_FLASH_CELL
	.word XT_PLUS
	.word XT_FLASH_WRITE
	.word XT_FLASH_SHADOW
	.word XT_FLASH_CACHE
	.word XT_FLASH_CELL
	.word XT_MOVE
	.word XT_EXIT
END TILDEBANGI


COLON "2!i", 2STOREI /* ( x1 x2 addr -- ) [addr] = x2, [addr+cellsize] = x1 (in the PV flash) */
	/* don't allow writing below dp0.flash */
	.word XT_DUP
	.word XT_DP0_FLASH
	.word XT_LESS
	.word XT_DOCONDBRANCH, 1f /* # if */
	.word XT_DOLITERAL
	.word -10    /* replace with more suitable value */
	.word XT_THROW
1:	/* # then */
	.word XT_MROT /* ( addr x1 x2 ) */
	.word XT_FLASH_CACHE, XT_STORE
	.word XT_FLASH_CACHE, XT_CELLPLUS, XT_STORE
	.word XT_DOFLASH_WRITE
	.word XT_EXIT
END 2STOREI

# ----------------------------------------------------------------------

COLON "~(dallot)", TILDEDODALLOT 
	.word XT_DP
	.word XT_FLASH_PAGE
	.word XT_MOD
	.word XT_ZEROEQUAL
	.word XT_DOCONDBRANCH,TILDEDODALLOT_0001 /* if */
	.word XT_DP_CACHE
	.word XT_ZEROEQUAL
	.word XT_DOCONDBRANCH,TILDEDODALLOT_0002 /* if */
	.word XT_DP
	.word XT_DOFLASH_ERASE
	.word XT_DOBRANCH,TILDEDODALLOT_0003
TILDEDODALLOT_0002: /* else */
	.word XT_DROP
	.word XT_FINISH
TILDEDODALLOT_0003: /* then */
TILDEDODALLOT_0001: /* then */
	.word XT_TO_R
	.word XT_R_FETCH
	.word XT_DP_CACHE
	.word XT_PLUS
	.word XT_FLASH_CELL
	.word XT_LESS
	.word XT_DOCONDBRANCH,TILDEDODALLOT_0004 /* if */
	.word XT_R_FETCH
	.word XT_CALLOT
	.word XT_R_FROM
	.word XT_DP
	.word XT_PLUS
	.word XT_DOTO
	.word XT_DP
	.word XT_DOBRANCH,TILDEDODALLOT_0005
TILDEDODALLOT_0004: /* else */
	.word XT_R_FETCH
	.word XT_DP_CACHE
	.word XT_PLUS
	.word XT_FLASH_CELL
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,TILDEDODALLOT_0006 /* if */
	.word XT_ZERO
	.word XT_DOTO
	.word XT_DP_CACHE
	.word XT_R_FROM
	.word XT_DP
	.word XT_PLUS
	.word XT_DUP
	.word XT_DOTO
	.word XT_DP
	.word XT_FLASH_WRITE
	.word XT_DOBRANCH,TILDEDODALLOT_0007
TILDEDODALLOT_0006: /* else */
	.word XT_R_FROM
	.word XT_DROP
	.word XT_FINISH
TILDEDODALLOT_0007: /* then */
TILDEDODALLOT_0005: /* then */
	.word XT_EXIT
END TILDEDODALLOT

