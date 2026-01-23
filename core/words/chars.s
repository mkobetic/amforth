# SPDX-License-Identifier: GPL-3.0-only
/*
WORD:  chars
STACK: ( n1 -- n2 )
MOTIF: 
CATEG:
STDID: core/CHARS
SHORT: n2 is the size in address units of n1 characters.
*/

IMMED "chars", MYCHARS
      .word XT_EXIT
