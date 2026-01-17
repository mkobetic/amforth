# SPDX-License-Identifier: GPL-3.0-only
IMMED "does>" , DOES #
      .word XT_COMPILE , XT_DODOES
      .word XT_COMPILE , PFA_XDODOES 
      .word XT_EXIT

# runtime part of does>
COLON "(dodoes)" , DODOES
        .word XT_R_FROM
        .word XT_NEWEST
        .word XT_CELLPLUS
        .word XT_FETCH
        .word XT_FETCH
        .word XT_NFA2XT
#        .word XT_STOREI
        .word XT_STORE
        .word XT_EXIT

CODEWORD "XDODOES" , XDODOES
dodoes:
  savetos
  mv s3, s1
  push s2
  lw s2, -4(s1)
  addi s2, s2, 4
  NEXT

