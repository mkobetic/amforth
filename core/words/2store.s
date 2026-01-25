# SPDX-License-Identifier: GPL-3.0-only
/*
WORD:  2!
STACK: ( x1 x2 a -- )
MOTIF: 
CATEG: double
STDIN: core/TwoStore
SHORT: Store cell pair x1 x2 at a, with x2 at a and x1 at a cell+
*/

#: 2!  ( lsw msw addr -- )
#    SWAP OVER !  CELL+ ! ;

COLON "2!" , 2STORE
      .word XT_SWAP
      .word XT_OVER
      .word XT_STORE
      .word XT_CELLPLUS
      .word XT_STORE
      .word XT_EXIT
      
