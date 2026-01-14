# SPDX-License-Identifier: GPL-3.0-only
# TODO
# need freeze (exists but needs retooling)

.extern eeprom_buf
.extern eeprom

CONSTANT "core-wordlist" , CORE_WORDLIST , core_wordlist
CONSTANT "eeprom"       , EEPROM     , eeprom 
CONSTANT "(eeprom)"     , EEP_BUF    , eeprom_buf   # 256B ram buffer
VALUE "dp.eeprom"       , DP_EEP     , 0 
VALUE "eeprom.empty?"   , EEPROMDOTEMPTYQ,0

CODEWORD "eeprom.up" , EEPROMDOTUP
    li      t2, 256         # Load byte count
    la     t3, eeprom     # t3 = source pointer
    la     t4, eeprom_buf     # t4 = destination pointer

1:
    lb      t5, 0(t3)        # Load 1 byte from source
    sb      t5, 0(t4)        # Store 1 byte to destination
    
    addi    t3, t3, 1        # Increment source pointer
    addi    t4, t4, 1        # Increment destination pointer
    addi    t2, t2, -1       # Decrement counter
    
    bnez    t2, 1b
    NEXT 

COLON "eeprom.xxxx" , EEPROMDOTXXXX # ( -- ) EEPROM: clear all 
    .word XT_EEPROMDOTUNLOCK 
    .word XT_EEPROMDOTERASE 
    .word XT_EEPROMDOTCLEAR 
    .word XT_EEPROMDOTSAVE 
    .word XT_EEPROMDOTLOCK 
    .word XT_STDDOTUNLOCK 
    .word XT_DP0DOTFLASH
    .word XT_STDDOTERASE 
    .word XT_EEPROMDOTWARM
	.word XT_EXIT


COLON "eeprom.init" , EEPROMDOTINIT # ( -- ) EEPROM: if first run init eeprom and std flash page 
    .word XT_FIRST_RUN
    .word XT_EEPROM
	.word XT_FETCH
	.word XT_EQUAL
    .word XT_EEPROMDOTEMPTYQ
    .word XT_OR 
	.word XT_DOCONDBRANCH,EEPROMDOTINIT_0001 # if
    .word XT_EEPROMDOTUNLOCK 
    .word XT_EEPROMDOTERASE 
    .word XT_EEPROMDOTCLEAR 
    .word XT_EEPROMDOTSAVE 
    .word XT_EEPROMDOTLOCK 
    .word XT_STDDOTUNLOCK 
    .word XT_DP0DOTFLASH
    .word XT_STDDOTERASE 
EEPROMDOTINIT_0001: # then
	.word XT_EXIT

COLON "eeprom.freeze" , EEPROMDOTFREEZE # ( -- ) EEPROM:

    .word XT_FORTH_WORDLIST , XT_CORE_WORDLIST , XT_MINUS
    .word XT_EEP_BUF
    .word XT_STORE 

    # if in flash use dp if in ram us dp.flash 
    .word XT_MEMMODE
    .word XT_DOCONDBRANCH,EEPROMDOTFREEZE_0001 # if
    .word XT_DP
	.word XT_DOBRANCH,EEPROMDOTFREEZE_0002
EEPROMDOTFREEZE_0001: # else
	.word XT_DP_FLASH
EEPROMDOTFREEZE_0002: # then    
    .word XT_DP0DOTFLASH , XT_MINUS
    .word XT_EEP_BUF , XT_ONE , XT_CELLS , XT_PLUS 
    .word XT_STORE     

    .word XT_VP , XT_VP0 , XT_MINUS
    .word XT_EEP_BUF , XT_TWO , XT_CELLS, XT_PLUS
    .word XT_STORE 

    .word XT_EEPROMDOTSAVE 
    .word XT_EXIT

COLON "eeprom.warm" , EEPROMDOTWARM # ( -- ) EEPROM:
  .word XT_EEPROMDOTLOAD
  
  # update forth-wordlist 
  .word XT_EEP_BUF , XT_FETCH
  .word XT_CORE_WORDLIST , XT_PLUS
  .word XT_DOTO , XT_FORTH_WORDLIST

  # update flash_dp
  .word XT_EEP_BUF , XT_ONE , XT_CELLS , XT_PLUS , XT_FETCH
  .word XT_DP0DOTFLASH , XT_PLUS 
  .word XT_DOTO , XT_DP_FLASH 

  # update ram pool pointer 
  .word XT_EEP_BUF , XT_TWO , XT_CELLS , XT_PLUS , XT_FETCH
  .word XT_VP0 , XT_PLUS 
  .word XT_DOTO , XT_VP

  # update rom pool pointer
  #.word XT_FLASH_BUF , XT_DOLITERAL , 6 , XT_CELLS , XT_PLUS , XT_FETCH
  #.word XT_FLASH_BUF , XT_DOLITERAL , 7 , XT_CELLS , XT_PLUS , XT_FETCH
  #.word XT_PLUS , XT_DOTO , XT_ROM_P

  .word XT_EXIT

COLON "eeprom.load", EEPROMDOTLOAD # ( -- ) EEPROM: load eeprom ram buffer from eeprom
#      .word XT_EEPROM , XT_DOLITERAL , 0x08000000 , XT_PLUS
#      .word XT_EEP_BUF
#      .word XT_DOLITERAL
#      .word 256
#      .word XT_MOVE

       .word XT_EEPROMDOTUP
       .word XT_EXIT

      .word XT_EEPROM
      .word XT_EEP_BUF
      .word XT_DOLITERAL
      .word 0x100
      .word XT_MOVE
      .word XT_EXIT 

COLON "eeprom.clear", EEPROMDOTCLEAR # ( -- ) EEPROM: clear eeprom ram buffer 
      .word XT_EEP_BUF
      .word XT_DOLITERAL
      .word 256
      .word XT_ZERO
      .word XT_FILL
      .word XT_EXIT 

CODEWORD "eeprom.unlock", EEPROMDOTUNLOCK # ( -- ) EEPROM: Unlock eeprom (fast flash)

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

CODEWORD "eeprom.lock", EEPROMDOTLOCK # ( -- ) EEPROM: Lock eeprom (flash)

         li t0, R32_FLASH_CTLR
         lw t1, 0(t0)
         ori t1,t1, (1 << 7)
         sw t1, 0(t0)
         NEXT

.extern eeprom

CODEWORD "eeprom.erase" , EEPROMDOTERASE # ( -- ) EEPROM: Erase 256B eeprom ( fast flash )

      la  t0 , eeprom
      li  t1 , OFFSET
      add t0 , t0 , t1 
      li  t1 , 0xFFFFFF00     # make the page address 
      and t0 , t0, t1         # 

      li  t3, R32_FLASH_ADDR  # store page address 
      sw  t0, 0(t3)           #

      li  t0, R32_FLASH_CTLR
      lw  t1, 0(t0)
      li  t2, (1<<17)         # fast 256 byte page erase
      or  t1, t1, t2          # ...
      sw  t1, 0(t0)           # save in preparation

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

      NEXT


COLON "eeprom.save", EEPROMDOTSAVE # ( -- ) EEPROM: save eeprom ram buffer to eeprom (fast flash)
    .word XT_EEPROMDOTUNLOCK
    .word XT_EEPROMDOTERASE
    .word XT_EEP_BUF
    .word XT_EEPROM
    .word XT_DOLITERAL
    .word 0x08000000
    .word XT_PLUS
    .word XT_DOLITERAL
    .word 0xFFFFFF00
    .word XT_AND 
	.word XT_SWAP
	.word XT_PLUS_FLASH_PROG
	.word XT_WAIT_FLASH_BUSY
	.word XT_WAIT_FLASH_WRITING
	.word XT_DOLITERAL
	.word 64
	.word XT_ZERO
	.word XT_DODO
EEPROMDOTSAVE_0002: # do
	.word XT_2DUP
	.word XT_FETCH
	.word XT_SWAP
	.word XT_STORE
	.word XT_CELLPLUS
	.word XT_SWAP
	.word XT_CELLPLUS
	.word XT_SWAP
	.word XT_WAIT_FLASH_WRITING
	.word XT_DOLOOP,EEPROMDOTSAVE_0002 # loop
EEPROMDOTSAVE_0001: # (for ?do IF required) 
	.word XT_FLASH_PROG
	.word XT_WAIT_FLASH_BUSY
	.word XT_MINUS_FLASH_PROG
#	.word XT_DOLITERAL
#	.word 0x4002200c
#	.word XT_FETCH
#	.word XT_RDOT
#	.word XT_CR
#        .word XT_MINUS_FLASH_EOP
#	.word XT_WAIT_FLASH_EOP
        .word XT_2DROP
#        .word XT_DOTS
#        .word XT_CR
#	.word XT_WAIT_FLASH_BUSY
    .word XT_EEPROMDOTLOCK
	.word XT_EXIT


