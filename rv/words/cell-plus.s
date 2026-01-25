# SPDX-License-Identifier: GPL-3.0-only
/*
WORD:  cell+
STACK: ( a1 -- a2 )
MOTIF: 
CATEG: arithmetic 
STDIN: core/CELLplus
SHORT: Add the size in address units of a cell to a1, to give a2
*/


# -----------------------------------------------------------------------------
  CODEWORD "cell+", CELLPLUS # ( x -- x+4 ) STACK: Add four to TOS 
# -----------------------------------------------------------------------------
  addi s3, s3, 4
  NEXT
