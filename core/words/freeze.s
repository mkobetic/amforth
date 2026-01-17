# SPDX-License-Identifier: GPL-3.0-only
COLON "freeze" , FREEZE # ( -- ) DICT: 
      .word XT_TOFLUSH
      .word XT_ROM_UPDATE
      .word XT_EXIT
      
