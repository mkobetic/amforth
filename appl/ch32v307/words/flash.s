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

# keep for education 
.ifnb 
CODEWORD "flash.write" , FLASHDOTWRITE # ( flash ram -- )
   mv a0 , s3 
   lw a1 , 0(s4)
   jal FLASH_ProgramPage_Fast
   lw s3 , 4(s4)
   addi s4 , s4 , 8
   NEXT

.endif

# .ifnb 

# CODEWORD "flash.write" , FLASHDOTWRITE # ( a-ram a-flash -- ) FLASH: write 256 bytes at a-ram to a-flash

#         li t0 , 0xFFFFFF00 
#         mv t3 , s3              # flash address
#         and t3 , t3, t0 
#         lw t4 , 0(s4)           # ram address  
#         li t5 , 64              # counter  
        
#         li t0, R32_FLASH_CTLR   # set program flag 
#         lw t1, 0(t0)
#         li t2, (1<<16)          # FTPG RW Perform a fast page programming operation 
#         or t1, t1, t2    
#         sw t1, 0(t0)

#         li t0, R32_FLASH_STATR  # wait.busy 
# 1:      lw t1, 0(t0)
#         andi t1,t1, (1 << 0)
#         bne t1,zero,1b
        
#         li t0, R32_FLASH_STATR  # wait.writing 
# 1:      lw t1, 0(t0)
#         andi t1,t1, (1 << 1)
#         bne t1,zero,1b 

#         # s3 is working 

# 2:      lw s3, 0(t4)            # load from ram ...
#         sw s3, 0(t3)            # ... store in flash

#         addi t4, t4, 4          # increment ram
#         addi t3, t3, 4          # increment flash
#         addi t5, t5, -1         # decrement counter
        
#         li t0, R32_FLASH_STATR  # wait.writing 
# 1:      lw t1, 0(t0)
#         andi t1,t1, (1 << 1)
#         bne t1,zero,1b 

#         bne t5,zero,2b          # loop over 64 words 

#         li  t0, R32_FLASH_CTLR  # start program 
#         lw  t1, 0(t0)
#         li  t2, (1<<21)
#         or  t1,t1,t2
#         sw  t1, 0(t0)

        
#         li t0, R32_FLASH_STATR  # wait.busy 
# 1:      lw t1, 0(t0)
#         andi t1,t1, (1 << 0)
#         bne t1,zero,1b

#         li  t0, R32_FLASH_CTLR  # clear program flag 
#         lw  t1, 0(t0)
#         li  t2, ~(1<<16)        # FTPG RW clear fast page programming operation 
#         and t1, t1, t2    
#         sw  t1, 0(t0)


#         li t0, R32_FLASH_STATR  # wait.busy 
# 1:      lw t1, 0(t0)
#         andi t1,t1, (1 << 0)
#         bne t1,zero,1b

#         lw s3 , 4(s4)
#         addi s4 , s4 , 8

#         NEXT
# .else        
# #----------------------------------------------------------------------
# COLON "flash.write", FLASHDOTWRITE # ( a-ram a-flash -- ) FLASH: write 256 bytes at a-ram to a-flash
#         .word XT_DOLITERAL
#         .word 0xFFFFFF00
#         .word XT_AND 
# 	.word XT_SWAP
# 	.word XT_PLUS_FLASH_PROG
# 	.word XT_WAIT_FLASH_BUSY
# 	.word XT_WAIT_FLASH_WRITING
# 	.word XT_DOLITERAL
# 	.word 64
# 	.word XT_ZERO
# 	.word XT_DODO
# FLASHDOTWRITE_0002: # do
# 	.word XT_2DUP
# 	.word XT_FETCH
# 	.word XT_SWAP
# 	.word XT_STORE
# 	.word XT_CELLPLUS
# 	.word XT_SWAP
# 	.word XT_CELLPLUS
# 	.word XT_SWAP
# 	.word XT_WAIT_FLASH_WRITING
# 	.word XT_DOLOOP,FLASHDOTWRITE_0002 # loop
# FLASHDOTWRITE_0001: # (for ?do IF required) 
# 	.word XT_FLASH_PROG
# 	.word XT_WAIT_FLASH_BUSY
# 	.word XT_MINUS_FLASH_PROG
# #	.word XT_DOLITERAL
# #	.word 0x4002200c
# #	.word XT_FETCH
# #	.word XT_RDOT
# #	.word XT_CR
# #        .word XT_MINUS_FLASH_EOP
# #	.word XT_WAIT_FLASH_EOP
#         .word XT_2DROP
# #        .word XT_DOTS
# #        .word XT_CR
# #	.word XT_WAIT_FLASH_BUSY
# 	.word XT_EXIT
# ----------------------------------------------------------------------
CODEWORD "~flash.busy" , WAIT_FLASH_BUSY # ( -- ) FLASH: Busy loop exit when FLASH controller ready to proceed
         li t0, R32_FLASH_STATR
1:
         lw t1, 0(t0)
         andi t1,t1, (1 << 0)
         bne t1,zero,1b 
         NEXT

CODEWORD "~flash.writing" , WAIT_FLASH_WRITING # ( -- ) FLASH: Busy loop exit when FLASH controller ready to write
         li t0, R32_FLASH_STATR
1:
         lw t1, 0(t0)
         andi t1,t1, (1 << 1)
         bne t1,zero,1b 
         NEXT
         
CODEWORD "+flash.prog" , PLUS_FLASH_PROG # ( -- ) FLASH: Set programming fast mode flag
         li t0, R32_FLASH_CTLR
         lw t1, 0(t0)
         li t2, (1<<16) # FTPG RW Perform a fast page programming operation 
         or t1, t1, t2    
         sw t1, 0(t0)
         NEXT

CODEWORD "-flash.prog" , MINUS_FLASH_PROG # ( -- ) FLASH: Unset programming fast mode flag
         li  t0, R32_FLASH_CTLR
         lw  t1, 0(t0)
         li  t2, ~(1<<16) # FTPG RW Perform a fast page programming operation 
         and t1, t1, t2    
         sw  t1, 0(t0)
         NEXT


CODEWORD "flash.prog" , FLASH_PROG # ( -- ) FLASH: Start program erase / write process
         li  t0, R32_FLASH_CTLR
         lw  t1, 0(t0)
         li  t2, (1<<21)
         or  t1,t1,t2
         sw  t1, 0(t0)
         NEXT

.ifnb 
CODEWORD "-flash.eop" , MINUS_FLASH_EOP # ( -- ) FLASH: Unset TOP flag
         li  t0, R32_FLASH_STATR
         lw  t1, 0(t0)
         ori t1, t1, (1<<5)
         sw  t1, 0(t0)
         NEXT


CODEWORD "~flash.eop" , WAIT_FLASH_EOP # ( -- ) FLASH: Busy loop exit when FLASH controller ready to write
         li t0, R32_FLASH_STATR
1:
         lw t1, 0(t0)
         andi t1,t1, (1 << 5)
         bne t1,zero,1b 
         NEXT
.endif          

# .endif
# #----------------------------------------------------------------------



CONSTANT "EOW" , EOW , 0xE339E339 

CONSTANT "flash.low"    , FLASH_LOW   , flash.low

CONSTANT "dp0.flash"   , DP0DOTFLASH  , dp0.flash
CONSTANT "flash.max"    , FLASH_MAX  , flash.max

#CODEWORD "flash.mode" , FLASH_MODE
#  mv a0 , s3
#  jal FLASH_Enhance_Mode
#  loadtos
#  NEXT

#CODEWORD "flash.lock", FLASH_LOCK
#  jal FLASH_Lock_Fast
#  NEXT

CODEWORD "flash.lock", FLASH_LOCK # ( -- ) FLASH: Lock flash

         li t0, R32_FLASH_CTLR
         lw t1, 0(t0)
         ori t1,t1, (1 << 7)
         sw t1, 0(t0)
         NEXT

#CODEWORD "flash.unlock", FLASH_UNLOCK 
#  jal FLASH_Unlock_Fast
#  NEXT

.equ OFFSET, 0x08000000

COLON "h,", HCOMMA 
	.word XT_DP
	.word XT_MEMMODE
	.word XT_DOCONDBRANCH,HCOMMA_0001 # if
    .word XT_HBANGI
	.word XT_DOBRANCH,HCOMMA_0002
HCOMMA_0001: # else
	.word XT_HSTORE
HCOMMA_0002: # then
	.word XT_TWO
	.word XT_DALLOT
	.word XT_EXIT

COLON "q,", QCOMMA
    .word XT_DP
	.word XT_DP
	.word XT_MEMMODE
	.word XT_DOCONDBRANCH,QCOMMA_0001 # if
	.word XT_BANGI
	.word XT_DOBRANCH,QCOMMA_0002
QCOMMA_0001: # else
	.word XT_STORE
QCOMMA_0002: # then
	.word XT_CELL
	.word XT_DALLOT
	.word XT_EXIT

# ----------------------------------------------------------------------
# THIS IS THE PART TW 

.if WANT_QEM_BUILD
    COLON "(h!i)" , INT_STORE
    .word XT_HSTORE
    .word XT_ZERO  # this is here whilst the real INT_STORE leaves n 
    .word XT_EXIT 
.else

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

      li  t0, R32_FLASH_STATR
      lw  t1, 0(t0)
      andi t1, t1, (1<<5)
      savetos
      add s3 , t1 , 0 

      NEXT
      
.endif 

CODEWORD "std.unlock", STDDOTUNLOCK # ( -- ) FLASH: Unlock flash

      li t0 , R32_FLASH_KEYR
      li t1 , 0x45670123
      sw t1 , 0(t0)
      li t1 , 0xCDEF89AB
      sw t1 , 0(t0)

NEXT

COLON "!i", BANGI 
	.word XT_2DUP
	.word XT_HBANGI
	.word XT_TWO
	.word XT_PLUS
	.word XT_SWAP
    .word XT_WORDSWAP
	.word XT_SWAP
	.word XT_HBANGI
	.word XT_EXIT
     
COLON "h!i", HBANGI
    .word XT_STDDOTUNLOCK
	.word XT_TUCK
    .word XT_INT_STORE
    .word XT_DOT
    .word XT_CR 
	.word XT_DUP
	.word XT_DOLITERAL
	.word 0xffe
	.word XT_AND
	.word XT_DOLITERAL
	.word 0xffe
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,HBANGI_0001 # if
	.word XT_TWO
	.word XT_PLUS
    .word XT_STDDOTERASE
    STRING "erasing next page"
    .word XT_TYPE
    .word XT_CR 
	.word XT_DOBRANCH,HBANGI_0002
HBANGI_0001: # else
	.word XT_DROP
HBANGI_0002: # then
    .word XT_1MS
	.word XT_EXIT

CODEWORD "std.erase" , STDDOTERASE # ( a-flash -- ) FLASH: Erase 256B page flash-a is in 

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


CODEWORD "flash.unlock", FLASH_UNLOCK # ( -- ) FLASH: Unlock flash

      li t0 , R32_FLASH_KEYR
      li t1 , 0x45670123
      sw t1 , 0(t0)
      li t1 , 0xCDEF89AB
      sw t1 , 0(t0)

      li t0 , R32_FLASH_MODEKEYR
      li t1 , 0x45670123
      sw t1 , 0(t0)
      li t1 , 0xCDEF89AB
      sw t1 , 0(t0)

      NEXT

#CODEWORD "flash.erase" , FLASH_ERASE
#  mv a0 , s3 
#  jal FLASH_ErasePage_Fast
#  loadtos
#  NEXT

CODEWORD "flash.erase" , FLASH_ERASE # ( a-flash -- ) FLASH: Erase 256B page flash-a is in 

      li  t0 , 0xFFFFFF00     # make the page address 
      and s3 , s3, t0         # from TOS

      li  t0, R32_FLASH_CTLR
      lw  t1, 0(t0)
      li  t2, (1<<17)         # fast 256 byte page erase
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
      li  t2, ~(1<<17)        # clear the erase flag
      and t1, t1, t2          # ...
      sw  t1, 0(t0)            # save in preparation
  
      loadtos
      NEXT



