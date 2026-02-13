# SPDX-License-Identifier: GPL-3.0-only

COLON "here", HERE
#  .word XT_VHERE
  .word XT_DHERE
  .word XT_EXIT
END HERE

# another attempt

CONSTANT "dp0.ram" , DP0DOTRAM , dp0.ram /* initial RAM dictionary pointer */
END DP0DOTRAM
VALUE "dp.ram"   , DP_RAM   , dp0.ram /* RAM dictionary pointer */
END DP_RAM

CONSTANT "dp0.flash"   , DP0_FLASH  , dp0.flash /* initial flash dictionary pointer */
END DP0_FLASH

VALUE "dp.flash" , DP_FLASH , dp0.flash /* flash dictionary pointer */
END DP_FLASH

VALUE "dp", DP, dp0.ram /* dictionary pointer */
END DP


COLON ">flash" , TO_FLASH /* compile new words to flash */
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
END TO_FLASH

COLON ">ram" , TO_RAM /* compile new words to RAM */
  .word XT_MEMMODE , XT_DOCONDBRANCH , TORAM0
  .word XT_DP , XT_DOTO, XT_DP_FLASH
  .word XT_DP_RAM
  .word XT_DOTO, XT_DP
  .word XT_ZERO , XT_DOTO, XT_MEMMODE
  .word XT_DOLITERAL, XT_RAM_WORDLIST , XT_DOTO , XT_CURRENT
TORAM0:  
  .word XT_EXIT
END TO_RAM
