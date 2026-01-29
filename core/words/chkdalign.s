# SPDX-License-Identifier: GPL-3.0-only
/*
WORD:  chkdalign
STACK: ( -- ) 
MOTIF: 
CATEG: system
STDID: 
SHORT: check DP for cell alignment, throw exception (-9) if not 
*/

COLON "chkdalign", CHKDALIGN 
	.word XT_DP
	.word XT_DUP
	.word XT_ALIGNED
	.word XT_MINUS
	.word XT_DOCONDBRANCH,CHKDALIGN_0001 /* if */
	.word XT_DOLITERAL
	.word -9
	.word XT_THROW
CHKDALIGN_0001: /* then */
	.word XT_EXIT
