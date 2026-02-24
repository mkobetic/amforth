# SPDX-License-Identifier: GPL-3.0-only

COLON "variable", VARIABLE /* ( "<spaces>name" -- ) create variable definition for name */
      .word XT_FLAGDOTVAR
      .word XT_FLAGDOTPRIVATEQ
      .word XT_OR
      .word XT_DOTO
      .word XT_FLAGDOTHEADER
      .word XT_DOCREATE
      .word XT_REVEAL
      .word XT_COMPILE
      .word PFA_DOVARIABLE
      .word XT_ZERO
      .word XT_RAMCOMMA
      .word XT_LBRACKET
      .word XT_FLASHDOTFLUSH
      .word XT_EXIT 

COLON "variable~" , CLOAKED_VARIABLE
      .word XT_FLAGDOTVAR
      .word XT_FLAGDOTPRIVATE
      .word XT_OR
      .word XT_DOTO
      .word XT_FLAGDOTHEADER
      .word XT_DOCREATE
      .word XT_REVEAL
      .word XT_COMPILE
      .word PFA_DOVARIABLE
      .word XT_ZERO
      .word XT_RAMCOMMA
      .word XT_LBRACKET
      .word XT_FLASHDOTFLUSH
      .word XT_EXIT 

