# SPDX-License-Identifier: GPL-3.0-only
# COLON "here", HERE
#   .word XT_MEMMODE , XT_DOCONDBRANCH , HERE0
#   # compile to FLASH via ram buffer FLASH_BUF
#   .word XT_FORTH_WORDLIST
#   .word XT_FLASH_RAMP
#   .word XT_FETCH
#   .word XT_PLUS
#   .word XT_EXIT 
# HERE0:
#   # compile to RAM 
#   .word XT_DP, XT_EXIT

#save before flash fiddle 
COLON "here", HERE
  .word XT_DP, XT_EXIT

# another attempt


VALUE "dp.flash" , DP_FLASH , dp0.flash
VALUE "dp.ram"   , DP_RAM   , dp0.ram

#CONSTANT "dp.start" , DP_START , HERESTART

COLON ">flash" , TO_FLASH
  .word XT_MEMMODE, XT_DOCONDBRANCH , TOFLASH0
  .word XT_EXIT 
TOFLASH0:  
  .word XT_DP , XT_DOTO, XT_DP_RAM
  .word XT_DP_FLASH , XT_DOTO, XT_DP
  .word XT_TRUE, XT_DOTO, XT_MEMMODE
  .word XT_DOLITERAL , XT_FORTH_WORDLIST , XT_DOTO , XT_CURRENT
#  .word XT_DP           # just
#  .word XT_FLASHDOTLOAD # added 
  .word XT_EXIT

COLON ">ram" , TO_RAM
  .word XT_MEMMODE , XT_DOCONDBRANCH , TORAM0
  .word XT_DP , XT_DOTO, XT_DP_FLASH
  .word XT_DP_RAM
  .word XT_DOTO, XT_DP
  .word XT_ZERO , XT_DOTO, XT_MEMMODE
  .word XT_DOLITERAL, XT_RAM_WORDLIST , XT_DOTO , XT_CURRENT
TORAM0:  
  .word XT_EXIT



# COLON ">flush" , TOFLUSH
#   .word XT_EXIT # knobble Sat 13 Dec 25 12:48:20
#   .word XT_MEMMODE , XT_DOCONDBRANCH , TOFLUSH0
#   .word XT_FLASH_UNLOCK
#   .word XT_DP , XT_FLASH_OFF , XT_PLUS , XT_DUP
#   .word XT_FLASH_ERASE
#   .word XT_FLASH_BUF , XT_SWAP , XT_FLASHDOTWRITE
#   .word XT_FLASH_LOCK
  
# TOFLUSH0:  
#   .word XT_EXIT 

# ENVIRONMENT "hello", ENV_HELLO
#     STRING "Hello    "
#    .word XT_EXIT

# COLON ">flushlast" , TOFLUSHLAST
#   .word XT_EXIT # knobble Sat 13 Dec 25 12:48:20
# #  .word XT_ENV_ENV_HELLO , XT_TYPE , XT_CR 
#   .word XT_MEMMODE , XT_DOCONDBRANCH , TOFLUSHLAST0
#   .word XT_FLASH_UNLOCK
#   .word XT_DP , XT_FLASH_OFF , XT_PLUS , XT_1MINUS , XT_DUP
#   .word XT_FLASH_ERASE
#   .word XT_FLASH_BUF , XT_SWAP , XT_FLASHDOTWRITE
#   .word XT_FLASH_LOCK
  
# TOFLUSHLAST0:  
#   .word XT_EXIT 
