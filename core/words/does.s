# SPDX-License-Identifier: GPL-3.0-only
IMMED "does>" , DOES #
      .word XT_COMPILE , XT_DODOES

      .word XT_DOLITERAL
      .word PFA_XDODOES
      .word XT_DP
      .word XT_MINUS
      .word XT_DUP
      .word XT_DOLITERAL
      .word 0x00000FFF
      .word XT_AND
      .word XT_SWAP
      .word XT_DOLITERAL
      .word 0x800
      .word XT_PLUS
      .word XT_DOLITERAL
      .word 0xFFFFF000
      .word XT_AND
      .word XT_DOLITERAL
      .word 0x297
      .word XT_OR
      .word XT_COMMA
      .word XT_DOLITERAL
      .word 20 
      .word XT_LSHIFT
      .word XT_DOLITERAL
      # .word 0x28067 # jalr x0 , 0(t0)
      .word 0x28367   # jalr t1 , 0(t0)
      .word XT_OR
      .word XT_COMMA

      .word XT_EXIT

# runtime part of does>
COLON "(dodoes)" , DODOES

        .word XT_MEMMODE , XT_DOCONDBRANCH , DODOES0

         # compiling to flash

        .word XT_TOFLUSH  # needed as child header
                          # likely still in buffer

        .word XT_R_FROM    
        .word XT_NEWEST
        .word XT_FETCH        
        .word XT_FFA2CFA

        # check here for DP page 

        .word XT_DUP , XT_DOLITERAL , 0xFFFFFF00 , XT_AND
        .word XT_DP  , XT_DOLITERAL , 0xFFFFFF00 , XT_AND
        .word XT_MINUS , XT_DOCONDBRANCH , DODOES1

        # flash address to write to not in DP page
        
        .word XT_FLASH_STORE
        .word XT_EXIT

DODOES1: # flash address to write to in DP page

        .word XT_DOLITERAL
        .word 0xFF
        .word XT_AND
        .word XT_FLASH_BUF
        .word XT_PLUS
        .word XT_STORE
        .word XT_DOLITERAL # MFD debug 
        .word 0x2A         # MFD
        .word XT_EMIT      # MFD
        .word XT_CR        # MFD
        .word XT_TOFLUSH   # needed as changed child header
                           # likely still in buffer
        .word XT_EXIT

DODOES0: # compiling to ram 
        .word XT_R_FROM
        .word XT_NEWEST
        .word XT_FETCH        
        .word XT_FFA2CFA
        .word XT_STORE
        .word XT_EXIT

CODEWORD "XDODOES" , XDODOES
dodoes:
  savetos
  mv s3, s1
  push s2
  mv s2 , t1 
  NEXT

