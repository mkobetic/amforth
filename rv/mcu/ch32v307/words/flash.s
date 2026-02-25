# SPDX-License-Identifier: GPL-3.0-only
# Reference Manual p572 
# Chapter 32 Flash Memory and User Option Bytes
# HSI RC oscillator must be switched on
# Flash Enhanced Read Mode
# ... is this the mode where program executed
# ... need to exit this prior to flash program attempt

# This seems to be an important thing...
# Whilst 0x08000000 is mapped to 0x00000000 the
# C library routines seem to hang (not always) when
# fed 0x00008000 on a read and don't perfrom on a
# write. Solution is to add FLASH_OFF to the
# address returned by amforth and the linker


# \ LFA
# \ FFA
# \ NFA
# \ .
# \ .
# \ .
# \ .
# \ XT
# \ PFA
# \ .
# \ .
# \ .
# \ .
.equ R32_FLASH_KEYR     , 0x40022004 # FPEC key register X
.equ R32_FLASH_OBKEYR   , 0x40022008 # OBKEY register X 
.equ R32_FLASH_STATR    , 0x4002200C # Status register 0x00000000
.equ R32_FLASH_CTLR     , 0x40022010 # Control register 0x00000080
.equ R32_FLASH_ADDR     , 0x40022014 # Address register 0x00000000
.equ R32_FLASH_OBR      , 0x4002201C # Selection word register 0x03FFFFFC
.equ R32_FLASH_WPR      , 0x40022020 # Write protection register 0xFFFFFFF
.equ R32_FLASH_MODEKEYR , 0x40022024 # Extension key register X
.equ OFFSET, 0x08000000

CONSTANT "EOW" , EOW , 0xE339E339
END EOW

# ----------------------------------------------------------------------

.ifdef TARGET_QEM
.include "core/words/flash.s"
.endif

.ifdef TARGET_307

VALUE    "dp.cache" , DP_CACHE , 0
END DP_CACHE
VARIABLE "flash.cache" , FLASH_CACHE
END FLASH_CACHE

COLON "callot" , CALLOT
     .word XT_DP_CACHE
     .word XT_PLUS
     .word XT_DOTO
     .word XT_DP_CACHE
     .word XT_EXIT
END CALLOT

# ----------------------------------------------------------------------
COLON "~(c,)", TILDEDOCCOMMA 
	.word XT_FLASH_CACHE
	.word XT_DP_CACHE
	.word XT_PLUS
	.word XT_CSTORE
    .word XT_ONE
    .word XT_DALLOT
	.word XT_EXIT
END TILDEDOCCOMMA

# ----------------------------------------------------------------------
COLON "~(,)", TILDEDOCOMMA 
	.word XT_FLASH_CELL
	.word XT_TWO
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,DOCOMMA_0001 # if
	.word XT_DUP
	.word XT_FLASH_CACHE
	.word XT_HSTORE
	.word XT_TWO
	.word XT_DALLOT
	.word XT_WORDSWAP
	.word XT_FLASH_CACHE
	.word XT_HSTORE
	.word XT_TWO
	.word XT_DALLOT
	.word XT_DOBRANCH,DOCOMMA_0002
DOCOMMA_0001: # else
	.word XT_FLASH_CACHE
	.word XT_DP_CACHE
	.word XT_PLUS
	.word XT_STORE
	.word XT_CELL
	.word XT_DALLOT
DOCOMMA_0002: # then
	.word XT_EXIT
END TILDEDOCOMMA

# ----------------------------------------------------------------------

COLON "~!i", TILDESTORE_I
	/* don't allow writing below dp0.flash */
	.word XT_DUP, XT_DP0_FLASH, XT_LESS, XT_DOCONDBRANCH, 1f /* # if */
		/* replace with more suitable value */
		.word XT_DOLITERAL, -10, XT_THROW
1:	/* # then */
	.word XT_2DUP
	.word XT_INT_STORE
	.word XT_TWO
	.word XT_PLUS
	.word XT_SWAP
    .word XT_WORDSWAP
	.word XT_SWAP
	.word XT_INT_STORE
	.word XT_EXIT
END TILDESTORE_I

CODEWORD "(h!i)", INT_STORE # ( -- ) 

      li   t3, R32_FLASH_STATR
1:    lw   t1, 0(t3)          # contents of status
      andi t1, t1, 1          # busy
      bne  t1, zero, 1b       # branch if busy (t1!=0)

      li  t0, R32_FLASH_STATR
      lw  t1, 0(t0)
      ori t1, t1, (1<<5)
      sw  t1, 0(t0)

      li  t0, R32_FLASH_CTLR
      lw  t1, 0(t0)
      andi t1, t1, ~(1<<6)
      sw  t1, 0(t0)

      li  t0, R32_FLASH_CTLR
      lw  t1, 0(t0)
      li  t2, (1<<0)          # Set PG bit 
      or  t1, t1, t2          # 
      sw  t1, 0(t0)           # 

      lw  t2, 0(s4)

      li  t3, OFFSET
      add s3, s3, t3 
      sh  t2, 0(s3) 

      loadtos
      loadtos 
      
      li   t3, R32_FLASH_STATR
1:    lw   t1, 0(t3)          # contents of status
      andi t1, t1, 1          # busy
      bne  t1, zero, 1b       # branch if busy (t1!=0)

      li  t0, R32_FLASH_CTLR
      lw  t1, 0(t0)
      li  t2, ~(1<<0)          # Set PG bit 
      and t1, t1, t2          # 
      sw  t1, 0(t0)           #

      NEXT
END INT_STORE

.endif

CODEWORD "std.unlock", STDDOTUNLOCK # ( -- ) FLASH: Unlock flash

      li t0 , R32_FLASH_KEYR
      li t1 , 0x45670123
      sw t1 , 0(t0)
      li t1 , 0xCDEF89AB
      sw t1 , 0(t0)
      NEXT
END STDDOTUNLOCK

CODEWORD "std.erase" , STDDOTERASE # ( a-flash -- ) FLASH: Erase 4K page flash-a is in 

      li  t3, OFFSET
      add s3, s3, t3

      li  t0 , 0xFFFFF000     # make the page address 
      and s3 , s3, t0         # from TOS

      li  t0, R32_FLASH_CTLR
      lw  t1, 0(t0)
      li  t2, (1<<1)         
      or  t1, t1, t2          # ...
      sw  t1, 0(t0)           # save in preparation

      li  t3, R32_FLASH_ADDR  # store page address 
      sw  s3, 0(t3)           #

      lw  t1, 0(t0)           # t0 still has R32_FLASH_CTLR
      ori t1, t1, (1<<6)      # 
      sw  t1, 0(t0)           # start erasing...

      li   t3, R32_FLASH_STATR
1:    lw   t1, 0(t3)          # contents of status
      andi t1, t1, 1          # busy
      bne  t1, zero, 1b       # branch if busy (t1!=0)

      lw  t1, 0(t0)           # t0 still has R32_FLASH_CTLR
      li  t2, ~(1<<1)        # clear the erase flag
      and t1, t1, t2          # ...
      sw  t1, 0(t0)            # save in preparation
  
      loadtos
      NEXT
END STDDOTERASE

.ifdef TARGET_307

CODEALIAS "~flash.erase", TILDEFLASH_ERASE, STDDOTERASE /* ( addr -- ) erase flash page at addr */
END TILDEFLASH_ERASE

# ----------------------------------------------------------------------
COLON "~(dallot)", TILDEDODALLOT 
	.word XT_DP
	.word XT_FLASH_PAGE
	.word XT_MOD
	.word XT_ZEROEQUAL
	.word XT_DOCONDBRANCH, DODALLOT_0001 # if
	.word XT_DP_CACHE
	.word XT_ZEROEQUAL
	.word XT_DOCONDBRANCH, DODALLOT_0002 # if
	.word XT_DP
	.word XT_STDDOTERASE
	.word XT_DOBRANCH, DODALLOT_0003
DODALLOT_0002: # else
	.word XT_DROP
	.word XT_DOLITERAL, EFCACHE, XT_THROW
DODALLOT_0003: # then
DODALLOT_0001: # then
	.word XT_TO_R
	.word XT_R_FETCH
	.word XT_DP_CACHE
	.word XT_PLUS
	.word XT_FLASH_CELL
	.word XT_LESS
	.word XT_DOCONDBRANCH,DODALLOT_0004 # if
	.word XT_R_FETCH
	.word XT_CALLOT
	.word XT_R_FROM
	.word XT_DP
	.word XT_PLUS
	.word XT_DOTO
	.word XT_DP
	.word XT_DOBRANCH,DODALLOT_0005
DODALLOT_0004: # else
	.word XT_R_FETCH
	.word XT_DP_CACHE
	.word XT_PLUS
	.word XT_FLASH_CELL
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,DODALLOT_0006 # if
	.word XT_ZERO
	.word XT_DOTO
	.word XT_DP_CACHE
	.word XT_R_FROM
	.word XT_DP
	.word XT_PLUS
	.word XT_DUP
	.word XT_DOTO
	.word XT_DP
	.word XT_FDOTWRITE
	.word XT_DOBRANCH,DODALLOT_0007
DODALLOT_0006: # else
	.word XT_R_FROM
	.word XT_DROP
	.word XT_DOLITERAL, EFCELLA, XT_THROW
DODALLOT_0007: # then
DODALLOT_0005: # then
	.word XT_EXIT
END TILDEDODALLOT

# ----------------------------------------------------------------------                            
COLON "f.write", FDOTWRITE                                                                          
    .word XT_FLASH_CACHE                                                                          
    .word XT_HFETCH                                                                                 
    .word XT_SWAP                                                                                   
    .word XT_FLASH_CELL                                                                           
    .word XT_MINUS                                                                                  
    .word XT_INT_STORE                                                                              
    .word XT_EXIT
END FDOTWRITE
# ----------------------------------------------------------------------               

#======================================================================
# PVFLASH primitives

CODEALIAS "~pvflash.erase", TILDEPVFLASH_ERASE, STDDOTERASE /* ( addr -- ) erase flash page at addr */
END TILDEPVFLASH_ERASE

NONAME "~2!pvf", TILDE2STORE_PVF /* ( x1 x2 addr -- ) [addr] = x2, [addr+cellsize] = x1 (in the PV flash) */
	/* don't allow writing below pvflash.start */
	.word XT_DUP, XT_PVFLASH_START, XT_LESS, XT_DOCONDBRANCH, 1f
		/* replace with more suitable value */
		.word XT_DOLITERAL, -10, XT_THROW
1:	/* then */
	.word XT_TUCK, XT_STORE_I
	.word XT_CELLPLUS, XT_STORE_I
	.word XT_EXIT
END TILDE2STORE_PVF

.endif
