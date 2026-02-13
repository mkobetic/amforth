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

/*
: init.dp.flash ( -- ) \ set dp.flash to the first erased cell after end of flash dictionary
    \if forth-wordlist < dp0.flash then leave dp.flash set to dp0.flash
    forth-wordlist dp0.flash < if exit then
    \ find start of the next flash page after forth-wordlist
    forth-wordlist flash.page / 1+ flash.page *
    \ check the end of the page to see if was erased
    dup flash.page + cell- dup @ flash.erased == if \ ( start-of-page end-of-page )
      \ if it was search from the end of the page
      swap drop
    else
      \ if it wasn't, erase it and search from the end of previous page
      \ this assumes that valid dictionary content cannot extend more than
      \ flash page size past the forth-wordlist pointer
      drop dup flash.erase
    then \ ( erased-cell-to-search-from )
    \ then search back for the first dirty cell
    begin dup @ flash.erased = while
        cell- repeat
    \ set dp.flash to the erased flash cell after it
    cell+ flash.cell swap naligned to dp.flash
;
*/
COLON "init.dp.flash", INIT_DP_FLASH /* ( -- ) set dp.flash to the first erased cell after end of flash dictionary */
  /* Here we are assuming that flash page size is relatively large, at least several hundred bytes
    and that the last word in the dictionary is a lot shorter than that and therefore forth-wordlist
    is a reasonable approximation of the end of the dictionary. */
  /* if forth-wordlist < dp0.flash then leave dp.flash set to dp0.flash */
  .word XT_FORTH_WORDLIST, XT_DP0_FLASH, XT_LESS, XT_DOCONDBRANCH, 1f, XT_EXIT
1: 
  /* find start of the next flash page after forth-wordlist and go to the end of it */
  .word XT_FORTH_WORDLIST, XT_FLASH_PAGE, XT_SLASH, XT_1PLUS, XT_FLASH_PAGE, XT_STAR
  /* check the end of the page to see if was erased */
  .word XT_DUP, XT_FLASH_PAGE, XT_PLUS, XT_CELLMINUS /* ( start-of-page end-of-page ) */
  .word XT_DUP, XT_FETCH, XT_FLASH_ERASED, XT_EQUAL, XT_DOCONDBRANCH, 1f
    /* if it was search from the end of the page */
    .word XT_SWAP, XT_DROP, XT_DOBRANCH, 2f
1:  /* if it wasn't, erase it and search from the end of previous page
      this assumes that valid dictionary content cannot extend more than
      flash page size past the forth-wordlist pointer */
    .word XT_DROP, XT_DUP, XT_FLASH_ERASE
2: /* ( erased-cell-to-search-from ) */
  /* search back for the first dirty cell */
  .word XT_DUP, XT_FETCH, XT_FLASH_ERASED, XT_EQUAL, XT_DOCONDBRANCH, 3f
    .word XT_CELLMINUS, XT_DOBRANCH, 2b
3: /* set dp.flash to the erased flash cell after it */
  .word XT_CELLPLUS, XT_FLASH_CELL, XT_SWAP, XT_NALIGNED
  .word XT_DOTO, XT_DP_FLASH
  .word XT_EXIT
END INIT_DP_FLASH
