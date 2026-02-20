# SPDX-License-Identifier: GPL-3.0-only

IMMED "s\x22", SQUOTE /* ( -- addr u ) compiles a string to dictionary, at runtime leaves ( -- flash-addr count) on stack */
    .word XT_DOLITERAL
    .word 34  
    .word XT_PARSE       
    .word XT_STATE
    .word XT_FETCH
    .word XT_DOCONDBRANCH, PFA_SQUOTE1
      .word XT_SLITERAL
PFA_SQUOTE1:
    .word XT_EXIT
END SQUOTE
