# SPDX-License-Identifier: GPL-3.0-only
/*
WORD:  2@
STACK: ( a -- x1 x2 )
MOTIF: 
CATEG: double
STDIN: core/TwoFetch
SHORT: Fetch cell pair x1 x2 stored at a. x2 is stored at a and x1 at a cell+ 
*/


#: 2@  ( addr -- lsw msw )
#    DUP CELL+ @  SWAP @ ;

COLON "2@" , 2FETCH
      .word XT_DUP
      .word XT_CELLPLUS
      .word XT_FETCH
      .word XT_SWAP
      .word XT_FETCH
      .word XT_EXIT
      
