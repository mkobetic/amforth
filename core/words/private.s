# SPDX-License-Identifier: GPL-3.0-only
VALUE "public?" , PUBLICQ , -1

# MFD
# COLON "+public" , PLUSPUBLIC # ( -- ) DICT: 
#       .word XT_TRUE
#       .word XT_DOXLITERAL
#       .word XT_PUBLICQ
#       .word XT_DEFER_STORE
#       .word XT_EXIT
      
# COLON "-public" , MINUSPUBLIC  # ( -- )  DICT: 
#       .word XT_FALSE
#       .word XT_DOXLITERAL
#       .word XT_PUBLICQ
#       .word XT_DEFER_STORE
#       .word XT_EXIT

COLON "+private" , PLUSPRIVATE
# ( -- ) DICT: show with private words
      .word XT_FALSE
      .word XT_DOXLITERAL
      .word XT_PUBLICQ
      .word XT_DEFER_STORE
      .word XT_EXIT

COLON "-private" , MINUSPRIVATE
# ( -- ) DICT: show without private words
      .word XT_TRUE
      .word XT_DOXLITERAL
      .word XT_PUBLICQ
      .word XT_DEFER_STORE
      .word XT_EXIT
