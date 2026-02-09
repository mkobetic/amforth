# SPDX-License-Identifier: GPL-3.0-only
COLON "warm", WARM /* ( -- ) high level part of the boot sequence, VM is running */
/* This is the high level part of the boot sequence with the VM already running.
  After initializations calls TURNKEY and if TURNKEY returns calls QUIT
  to enter the endless outer interpreter loop.
  When called from within forth it is the equivalent of a soft RESET.

  MCUs may override this to inject additional initialization at specific points
*/
  .word XT_INIT_RAM   
  .word XT_LBRACKET   
  .word XT_TURNKEY    
  .word XT_QUIT       
  .word XT_EXIT       
END WARM
