# SPDX-License-Identifier: GPL-3.0-only
# this is the old one 
#COLON "variable", VARIABLE
#      .word XT_CREATE
#      .word XT_RAMHEREPLUSPLUS
#      .word XT_COMMA
#      .word XT_EXIT 

# this is the very old one 
# COLON "variable", VARIABLE
#       .word XT_CREATE
#       .word XT_HERE
#       .word XT_CELLPLUS
#       .word XT_COMMA
#       .word XT_DOLITERAL, 4
#       .word XT_ALLOT
#       .word XT_EXIT      

.ifnb 

COLON "variable" , VARIABLE
      .word XT_FLAGDOTVAR
      .word XT_DOTO
      .word XT_FLAGDOTHEADER
      .word XT_CREATE
      .word XT_RAMHEREPLUSPLUS
      .word XT_COMMA
      .word XT_LBRACKET
      .word XT_TOFLUSH 
      .word XT_EXIT 

COLON "variable~" , CLOAKED_VARIABLE
      .word XT_FLAGDOTVAR
      .word XT_FLAGDOTCLOAKED
      .word XT_OR
      .word XT_DOTO
      .word XT_FLAGDOTHEADER
      .word XT_CREATE
      .word XT_RAMHEREPLUSPLUS
      .word XT_COMMA
      .word XT_LBRACKET
      .word XT_TOFLUSH 
      .word XT_EXIT 
.else

COLON "variable" , VARIABLE
      .word XT_FLAGDOTVAR
      .word XT_FLAGDOTPRIVATEQ
      .word XT_OR
      .word XT_DOTO
      .word XT_FLAGDOTHEADER
      .word XT_CREATE
      .word XT_RAMHEREPLUSPLUS
      .word XT_COMMA
      .word XT_LBRACKET
#      .word XT_TOFLUSH 
      .word XT_EXIT 

COLON "variable~" , CLOAKED_VARIABLE
      .word XT_FLAGDOTVAR
      .word XT_FLAGDOTPRIVATE
      .word XT_OR
      .word XT_DOTO
      .word XT_FLAGDOTHEADER
      .word XT_CREATE
      .word XT_RAMHEREPLUSPLUS
      .word XT_COMMA
      .word XT_LBRACKET
#      .word XT_TOFLUSH 
      .word XT_EXIT 

.endif

