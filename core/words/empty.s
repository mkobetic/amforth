# SPDX-License-Identifier: GPL-3.0-only

COLON "empty", EMPTY
# ( -- ) DICT: empty RAM and non-core FLASH dictionaries
      .word XT_TRUE
      .word XT_DOTO
      .word XT_EEPROMDOTEMPTYQ
      .word XT_EEPROMDOTINIT
      .word XT_EEPROMDOTWARM
      .word XT_FALSE
      .word XT_DOTO
      .word XT_EEPROMDOTEMPTYQ
      .word XT_EXIT

# # transpiling empty.f on 2024/03/29 14:39:09
# # : empty.ram \# ( -- ) DICT: empty the RAM dictionary
# #     0 ['] ram-wordlist cell+ @ !
# #     rom>ram
# #     0 ram.buf 5 cells + ! \ zero ram pool offset
# #     ram>rom
# #     warm.reload
# # ;
# # 
# # : empty.flash \# ( -- ) DICT: empty non-core FLASH dictionary
# #     rom>ram
# #     \ ram.buf @ ['] forth-wordlist cell+ @ !
# #     0 ram.buf 1 cells + ! \ zero wordlist offset
# #     0 ram.buf 3 cells + ! \ zero flash.p offset
# #     ram>rom
# #     warm.reload
# # ;
# # 
# # : empty \# ( -- ) DICT: empty both RAM and non-core FLASH dictionaries
# #     empty.ram
# #     empty.flash
# # ;
# # 
# # 
# # 

# # ----------------------------------------------------------------------
# COLON "empty.ram", EMPTYDOTRAM # ( -- ) DICT: empty the RAM dictionary
# 	.word XT_ZERO
# 	.word XT_DOLITERAL
# 	.word XT_RAM_WORDLIST
# 	.word XT_CELLPLUS
# 	.word XT_FETCH
# 	.word XT_STORE
# 	.word XT_ROM_TO_RAM
# 	.word XT_ZERO
# 	.word XT_RAM_BUF
# 	.word XT_DOLITERAL
# 	.word 5
# 	.word XT_CELLS
# 	.word XT_PLUS
# 	.word XT_STORE
# 	.word XT_RAM_TO_ROM
# 	.word XT_WARM_RELOAD
# 	.word XT_EXIT
# # ----------------------------------------------------------------------
# COLON "empty.flash", EMPTYDOTFLASH # ( -- ) DICT: empty non-core FLASH dictionary
# 	.word XT_ROM_TO_RAM
# 	.word XT_ZERO
# 	.word XT_RAM_BUF
# 	.word XT_ONE
# 	.word XT_CELLS
# 	.word XT_PLUS
# 	.word XT_STORE
# 	.word XT_ZERO
# 	.word XT_RAM_BUF
# 	.word XT_DOLITERAL
# 	.word 3
# 	.word XT_CELLS
# 	.word XT_PLUS
# 	.word XT_STORE
# 	.word XT_RAM_TO_ROM
# 	.word XT_WARM_RELOAD
# 	.word XT_EXIT
# # ----------------------------------------------------------------------
# COLON "empty", EMPTY # ( -- ) DICT: empty both RAM and non-core FLASH dictionaries
# 	.word XT_EMPTYDOTRAM
# 	.word XT_EMPTYDOTFLASH
# 	.word XT_EXIT
# # ----------------------------------------------------------------------
