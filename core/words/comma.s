# SPDX-License-Identifier: GPL-3.0-only

CONSTANT "flash.mask" , FLASHDOTMASK , 0xFF

COLON ",", COMMA
    .word XT_DALIGN
	.word XT_DP
	.word XT_MEMMODE
	.word XT_DOCONDBRANCH,COMMA_0001
	# if
	.word XT_BANGI
	.word XT_DOBRANCH,COMMA_0002
COMMA_0001: # else
	.word XT_STORE
COMMA_0002: # then
	.word XT_CELL
	.word XT_DALLOT
	.word XT_EXIT


