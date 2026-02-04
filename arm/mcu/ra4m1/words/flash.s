# SPDX-License-Identifier: GPL-3.0-only

.equ flash_cell , 8 

VALUE     "dp.cache"    , DPDOTCACHE , 0
CONSTANT  "flash.cell"  , FLASHDOTCELL , flash_cell 
CONSTANT  "flash.page"  , FLASHDOTPAGE , 2048
NVARIABLE "flash.cache" , FLASHDOTCACHE , flash_cell / cellsize
NVARIABLE "flash.shadow" , FLASHDOTSHADOW , flash_cell / cellsize 
CONSTANT "dp0.flash"   , DP0DOTFLASH  , dp0.flash
CONSTANT "flash.max"    , FLASH_MAX  , flash.max

#======================================================================

CODEWORD "flash.erase" , FLASHDOTERASE /* ( fa -- ) erase page containing fa */ 
    ldr r3, =__flash_erase__       // Load RAM address of xxx
    orr r3, r3, #1                 // thumb bit fix 
    blx r3                         // Call it
NEXT

CODEWORD "(flash.write)" , LBRAFLASHDOTWRITERBRA
    ldr r3, =__flash_write__       // Load RAM address of xxx
    orr r3, r3, #1                 // thumb bit fix 
    blx r3                         // Call it
NEXT 

COLON "flash.write" , FLASHDOTWRITE /* ( fa -- ) write flash.cache to flash at fa - flash.cell */
    .word XT_FLASHDOTCELL
    .word XT_MINUS
    .word XT_LBRAFLASHDOTWRITERBRA
    .word XT_EXIT

#======================================================================

COLON "flash.init" , FLASHDOTINIT /* ( -- ) set defers for NFF */ 

     /* ' ~(dallot) to (dallot) */
     
    .word XT_DOLITERAL
    .word XT_TILDELPARENDALLOTRPAREN
    .word XT_DOLITERAL    
    .word XT_LPARENDALLOTRPAREN
    .word XT_CELLPLUS
	.word XT_FETCH
	.word XT_STORE

     /* ' ~(c,) to (c,) */
     
    .word XT_DOLITERAL
    .word XT_TILDELPARENCCOMMARPAREN
    .word XT_DOLITERAL
    .word XT_LPARENCCOMMARPAREN
    .word XT_CELLPLUS
	.word XT_FETCH
	.word XT_STORE

     /* ' ~(,) to (,) */
     
    .word XT_DOLITERAL
    .word XT_TILDELPARENCOMMARPAREN
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

    .word XT_EXIT

#======================================================================
# NFF defer targets ( the words that do the work ) 

COLON "callot" , CALLOT
     .word XT_DPDOTCACHE
     .word XT_PLUS
     .word XT_DOTO
     .word XT_DPDOTCACHE
     .word XT_EXIT
     
COLON "~(c,)", TILDELPARENCCOMMARPAREN 
	.word XT_FLASHDOTCACHE
	.word XT_DPDOTCACHE
	.word XT_PLUS
	.word XT_CSTORE
    .word XT_ONE
    .word XT_DALLOT
	.word XT_EXIT

COLON "~(,)",  TILDELPARENCOMMARPAREN 
	.word XT_FLASHDOTCACHE
	.word XT_DPDOTCACHE
	.word XT_PLUS
	.word XT_STORE
	.word XT_CELL
	.word XT_DALLOT
	.word XT_EXIT

COLON "~!i", TILDEBANGI 
	.word XT_DUP
	.word XT_DP0DOTFLASH
	.word XT_LESS
	.word XT_DOCONDBRANCH,TILDEBANGI_0001 /* # if */
	.word XT_THROW
	.word XT_DOLITERAL
	.word -10    /* replace with more suitable value */
TILDEBANGI_0001: /* # then */
	.word XT_FLASHDOTCACHE
	.word XT_FLASHDOTSHADOW
	.word XT_FLASHDOTCELL
	.word XT_MOVE
	.word XT_TO_R
	.word XT_FLASHDOTCACHE
	.word XT_STORE
	.word XT_DOLITERAL
    .word XT_NOP
	.word XT_FLASHDOTCACHE
	.word XT_CELLPLUS
	.word XT_STORE
	.word XT_R_FROM
	.word XT_FLASHDOTCELL
	.word XT_PLUS
	.word XT_FLASHDOTWRITE
	.word XT_FLASHDOTSHADOW
	.word XT_FLASHDOTCACHE
	.word XT_FLASHDOTCELL
	.word XT_MOVE
	.word XT_EXIT

# ----------------------------------------------------------------------

COLON "~(dallot)", TILDELPARENDALLOTRPAREN 
	.word XT_DP
	.word XT_FLASHDOTPAGE
	.word XT_MOD
	.word XT_ZEROEQUAL
	.word XT_DOCONDBRANCH,TILDELPARENDALLOTRPAREN_0001 /* if */
	.word XT_DPDOTCACHE
	.word XT_ZEROEQUAL
	.word XT_DOCONDBRANCH,TILDELPARENDALLOTRPAREN_0002 /* if */
	.word XT_DP
	.word XT_FLASHDOTERASE
	.word XT_DOBRANCH,TILDELPARENDALLOTRPAREN_0003
TILDELPARENDALLOTRPAREN_0002: /* else */
	.word XT_DROP
	.word XT_FINISH
TILDELPARENDALLOTRPAREN_0003: /* then */
TILDELPARENDALLOTRPAREN_0001: /* then */
	.word XT_TO_R
	.word XT_R_FETCH
	.word XT_DPDOTCACHE
	.word XT_PLUS
	.word XT_FLASHDOTCELL
	.word XT_LESS
	.word XT_DOCONDBRANCH,TILDELPARENDALLOTRPAREN_0004 /* if */
	.word XT_R_FETCH
	.word XT_CALLOT
	.word XT_R_FROM
	.word XT_DP
	.word XT_PLUS
	.word XT_DOTO
	.word XT_DP
	.word XT_DOBRANCH,TILDELPARENDALLOTRPAREN_0005
TILDELPARENDALLOTRPAREN_0004: /* else */
	.word XT_R_FETCH
	.word XT_DPDOTCACHE
	.word XT_PLUS
	.word XT_FLASHDOTCELL
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,TILDELPARENDALLOTRPAREN_0006 /* if */
	.word XT_ZERO
	.word XT_DOTO
	.word XT_DPDOTCACHE
	.word XT_R_FROM
	.word XT_DP
	.word XT_PLUS
	.word XT_DUP
	.word XT_DOTO
	.word XT_DP
	.word XT_FLASHDOTWRITE
	.word XT_DOBRANCH,TILDELPARENDALLOTRPAREN_0007
TILDELPARENDALLOTRPAREN_0006: /* else */
	.word XT_R_FROM
	.word XT_DROP
	.word XT_FINISH
TILDELPARENDALLOTRPAREN_0007: /* then */
TILDELPARENDALLOTRPAREN_0005: /* then */
	.word XT_EXIT


