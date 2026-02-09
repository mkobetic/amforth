# SPDX-License-Identifier: GPL-3.0-only

# COLON "warm.reload" , WARM_RELOAD
#   .word XT_ROM_TO_RAM

#   # update forth-wordlist 
#   .word XT_FLASH_BUF , XT_FETCH
#   .word XT_FLASH_BUF , XT_CELLPLUS , XT_FETCH
#   .word XT_PLUS , XT_DOTO , XT_FORTH_WORDLIST

#   # update flash pointer 
#   .word XT_FLASH_BUF , XT_CELLPLUS , XT_CELLPLUS , XT_FETCH
#   .word XT_FLASH_BUF , XT_CELLPLUS , XT_CELLPLUS , XT_CELLPLUS , XT_FETCH
#   .word XT_PLUS , XT_DOTO , XT_FLASH_P

#   # update flash_dp
#   .word XT_FLASH_P , XT_DOTO , XT_DP_FLASH 

#   # update ram pool pointer
#   .word XT_FLASH_BUF , XT_DOLITERAL , 4 , XT_CELLS , XT_PLUS , XT_FETCH
#   .word XT_FLASH_BUF , XT_DOLITERAL , 5 , XT_CELLS , XT_PLUS , XT_FETCH
#   .word XT_PLUS , XT_DOTO , XT_RAM_POOLP

#   # update rom pool pointer
#   .word XT_FLASH_BUF , XT_DOLITERAL , 6 , XT_CELLS , XT_PLUS , XT_FETCH
#   .word XT_FLASH_BUF , XT_DOLITERAL , 7 , XT_CELLS , XT_PLUS , XT_FETCH
#   .word XT_PLUS , XT_DOTO , XT_ROM_P

#   .word XT_EXIT

COLON "warm", WARM /* ( -- ) high level part of the boot sequence, VM is running */
/* This is the high level part of the boot sequence with the VM already running.
  After initializations calls TURNKEY and if TURNKEY returns calls QUIT
  to enter the endless outer interpreter loop.
  When called from within forth it is the equivalent of a soft RESET.

  MCUs may override this to inject additional initialization at specific points
*/
  .word XT_INIT_RAM   
  .word XT_LBRACKET 

#  .word XT_WARM_RELOAD
  
#  .word XT_EEPROMDOTINIT
#  .word XT_EEPROMDOTWARM
#  .word XT_STDDOTUNLOCK
  
  .word XT_TURNKEY    
  
  .word XT_QUIT       
 
  .word XT_EXIT       
END WARM
