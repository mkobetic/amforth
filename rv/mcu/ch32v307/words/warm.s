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

  /* initialize values and defers to their defaults */
  .word XT_INIT_RAM

  /* initialize flash system */
  .word XT_FLASH_INIT

  /* initialize pvalue system */
  .word XT_PVFLASH_INIT
  .word XT_QFIRST_BOOT, XT_DOCONDBRANCH, 1f
    .word XT_PVARENA1, XT_DOTO, XT_PVARENA, XT_PV_RESET_HARD
    .word XT_DOBRANCH, 2f 
1: /* else */
    .word XT_PV_INIT
2:
  /* check and mark first-boot done */
  .word XT_QFIRST_BOOT, XT_DOCONDBRANCH, 1f
    .word XT_FIRST_BOOT_DONE
1:
  /* find the end of the used flash and set DP;
    do it after first-boot-done so that the first-boot page is erased already */
  .word XT_INIT_DP_FLASH

  .word XT_LBRACKET  
  .word XT_TURNKEY    
  .word XT_QUIT       
  .word XT_EXIT       
END WARM

NONAME FLASH_INIT
.ifdef TARGET_307
  .word XT_FLASHDOT307
  # .word XT_EEPROMDOTINIT                                                           
  # .word XT_EEPROMDOTWARM                                                           
  .word XT_STDDOTUNLOCK                                                            
.endif
  .word XT_EXIT
END FLASH_INIT

NONAME PVFLASH_INIT
.ifdef TARGET_307
  /* ' 2!i is 2!pvf */
  .word XT_DOLITERAL, XT_2STOREI, XT_DOLITERAL, XT_2STORE_PVF, XT_DEFER_STORE  
  /* ' std.erase is pvflash.erase */
  .word XT_DOLITERAL, XT_STDDOTERASE, XT_DOLITERAL, XT_PVFLASH_ERASE, XT_DEFER_STORE
.endif
  .word XT_EXIT
END PVFLASH_INIT

.ifdef TARGET_307
NONAME 2STOREI /* ( x1 x2 addr -- ) [addr] = x2, [addr+cellsize] = x1 (in the PV flash) */
  .word XT_TUCK, XT_TILDEBANGI
  .word XT_CELLPLUS, XT_TILDEBANGI
  .word XT_EXIT
END 2STOREI
.endif
