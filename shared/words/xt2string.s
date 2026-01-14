# SPDX-License-Identifier: GPL-3.0-only
COLON "xt>string" , XT2STRING
# ( xt -- ca cu ) DICT: Leave word string on stack (XT **must** have NFA)
      .word XT_XT2NFA
      .word XT_NFA2STRING
      .word XT_EXIT
