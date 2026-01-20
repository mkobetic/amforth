# SPDX-License-Identifier: GPL-3.0-only

COLON "s,", SCOMMA 
	.word XT_DUP
	.word XT_CCOMMA
	.word XT_ZERO
	.word XT_DODO
SCOMMA_0002: # do
	.word XT_DUP
	.word XT_I
	.word XT_PLUS
	.word XT_CFETCH
	.word XT_CCOMMA
	.word XT_DOLOOP,SCOMMA_0002 /* loop */
SCOMMA_0001: # (for ?do IF required) 
	.word XT_DROP
	.word XT_DP
	.word XT_DUP
	.word XT_ALIGNED
	.word XT_SWAP
	.word XT_MINUS
	.word XT_ZERO
	.word XT_QDOCHECK, XT_DOCONDBRANCH,SCOMMA_0003 /* ?do */
	.word XT_DODO
SCOMMA_0004: # do
	.word XT_MINUSONE
	.word XT_CCOMMA
	.word XT_DOLOOP,SCOMMA_0004 /* loop */
SCOMMA_0003: # (for ?do IF required) 
	.word XT_EXIT

