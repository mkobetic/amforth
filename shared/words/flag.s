# SPDX-License-Identifier: GPL-3.0-only
VALUE    "flag.header"    , FLAGDOTHEADER   , 0x00

# This is a bit mutated. flag.private? is not a
# true boolean flag. It takes either 0 or flag.private

VALUE    "flag.private?"  , FLAGDOTPRIVATEQ , 0x00

# The flags

CONSTANT "flag.code"      , FLAGDOTCODE     , 0x000
CONSTANT "flag.var"       , FLAGDOTVAR      , 0x001
CONSTANT "flag.dvar"      , FLAGDOTDVAR     , 0x002
CONSTANT "flag.colon"     , FLAGDOTCOLON    , 0x004
CONSTANT "flag.con"       , FLAGDOTCON      , 0x008
CONSTANT "flag.immed"     , FLAGDOTIMMED    , 0x010
CONSTANT "flag.value"     , FLAGDOTVALUE    , 0x020
CONSTANT "flag.defer"     , FLAGDOTDEFER    , 0x040
CONSTANT "flag.init"      , FLAGDOTINIT     , 0x080
CONSTANT "flag.table"     , FLAGDOTTABLE    , 0x100
CONSTANT "flag.cloaked"   , FLAGDOTCLOAKED  , 0x80000000
CONSTANT "flag.private"   , FLAGDOTPRIVATE  , 0x80000000

COLON "private" , PRIVATE
# ( -- ) DICT: Future words marked as private
      .word XT_FLAGDOTPRIVATE
      .word XT_DOXLITERAL
      .word XT_FLAGDOTPRIVATEQ
      .word XT_DEFER_STORE
      .word XT_EXIT
      
COLON "public" , PUBLIC
# ( -- )  DICT: Future words marked as public  
      .word XT_ZERO
      .word XT_DOXLITERAL
      .word XT_FLAGDOTPRIVATEQ
      .word XT_DEFER_STORE
      .word XT_EXIT

