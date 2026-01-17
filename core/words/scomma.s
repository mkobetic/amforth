# SPDX-License-Identifier: GPL-3.0-only

COLON "s,", SCOMMA 
	.word XT_DUP
	.word XT_ONE
	.word XT_DOLITERAL
	.word 0x100
	.word XT_WITHIN
	.word XT_INVERT
	.word XT_DOCONDBRANCH,SCOMMA_0001
	# if
	.word XT_2DROP
    .word XT_DALIGN
	.word XT_FINISH
SCOMMA_0001: # then
    .word XT_DALIGN
	.word XT_TO_R
	.word XT_DUP
	.word XT_CFETCH
	.word XT_DOLITERAL
	.word 8
	.word XT_LSHIFT
	.word XT_R_FETCH
	.word XT_OR
    .word XT_HCOMMA
	.word XT_R_FROM
	.word XT_1MINUS
	.word XT_TO_R
	.word XT_1PLUS
	.word XT_R_FETCH
	.word XT_ZEROEQUAL
	.word XT_DOCONDBRANCH,SCOMMA_0002
	# if
	.word XT_RDROP
	.word XT_DROP
    .word XT_DALIGN    
	.word XT_FINISH
SCOMMA_0002: # then
	.word XT_R_FETCH
	.word XT_2SLASH
	.word XT_ZERO
	.word XT_QDOCHECK, XT_DOCONDBRANCH,SCOMMA_0003
	# ?do
	.word XT_DODO
SCOMMA_0004: # do
	.word XT_DUP
	.word XT_CFETCH
	.word XT_SWAP
	.word XT_1PLUS
	.word XT_DUP
	.word XT_CFETCH
	.word XT_DOLITERAL
	.word 8
	.word XT_LSHIFT
	.word XT_ROT
	.word XT_OR
	.word XT_DUP
	.word XT_DOT
    .word XT_HCOMMA
	.word XT_1PLUS
	.word XT_DOLOOP,SCOMMA_0004
	# loop
SCOMMA_0003: # (for ?do IF required) 
	.word XT_R_FETCH
	.word XT_TWO
	.word XT_SLASHMOD
	.word XT_DROP
	.word XT_ZEROEQUAL
	.word XT_INVERT
	.word XT_DOCONDBRANCH,SCOMMA_0005
	# if
	.word XT_CFETCH
	.word XT_DOLITERAL
	.word 0xff00
	.word XT_OR
    .word XT_HCOMMA
	.word XT_DOBRANCH,SCOMMA_0006
SCOMMA_0005: # else
	.word XT_DROP
SCOMMA_0006: # then
	.word XT_RDROP
    .word XT_DALIGN    
	.word XT_EXIT
#=====================================================================
#======================================================================


# original below

# COLON "s,", SCOMMA
#     .word XT_DUP, XT_CCOMMA
#     .word XT_ZERO
#     .word XT_QDOCHECK
#     .word XT_DOCONDBRANCH, PFA_SCOMMA2
#     .word XT_DODO
# PFA_SCOMMA1:
#     .word XT_DUP
#     .word XT_CFETCH
#     .word XT_CCOMMA
#     .word XT_1PLUS
#     .word XT_DOLOOP
#     .word PFA_SCOMMA1
# PFA_SCOMMA2:
#     .word XT_DROP
#     .word XT_DP, XT_ALIGNED, XT_DOTO, XT_DP
#     .word XT_EXIT
