# SPDX-License-Identifier: GPL-3.0-only

COLON "search-wordlist",SEARCH_WORDLIST

    .word XT_TO_R
    .word XT_ZERO
    .word XT_DOLITERAL
    .word XT_ISWORD
    .word XT_R_FROM
    .word XT_TRAVERSEWORDLIST
    .word XT_DUP
    .word XT_ZEROEQUAL
    .word XT_DOCONDBRANCH,PFA_SEARCH_WORDLIST1
       .word XT_2DROP
       .word XT_DROP
       .word XT_ZERO
       .word XT_EXIT
PFA_SEARCH_WORDLIST1:
      .word XT_DUP
      .word XT_FFA2CFA
      .word XT_SWAP
# MFD      .word XT_NAME2FLAGS
      .word XT_IMMEDIATEQ
    .word XT_EXIT

NONAME ISWORD
    .word XT_TO_R
    .word XT_DROP
    .word XT_2DUP
    .word XT_R_FETCH
    .word XT_FFA2STRING
    .word XT_COMPARE
    .word XT_DOCONDBRANCH,PFA_ISWORD3
      .word XT_R_FROM
      .word XT_DROP
      .word XT_ZERO
      .word XT_TRUE
      .word XT_EXIT
PFA_ISWORD3:
      .word XT_2DROP
      .word XT_R_FROM
      .word XT_ZERO
      .word XT_EXIT
