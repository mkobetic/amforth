# SPDX-License-Identifier: GPL-3.0-only

COLON "pong!" , PONG # ( n fa -- ) 

        # check here for DP page 

        .word XT_DUP , XT_DOLITERAL , 0xFFFFFF00 , XT_AND
        .word XT_DP  , XT_DOLITERAL , 0xFFFFFF00 , XT_AND
        .word XT_MINUS , XT_DOCONDBRANCH , PONG1

        # flash address to write to not in DP page
        
        .word XT_FLASH_STORE
        .word XT_FINISH

PONG1: # flash address to write to is in DP page

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

