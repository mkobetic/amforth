# SPDX-License-Identifier: GPL-3.0-only

.ifnb YES
COLON "allot", ALLOT
     .word XT_DP
     .word XT_TUCK
     .word XT_PLUS
     .word XT_DOTO, XT_DP

     .word XT_MEMMODE 
     .word XT_DOCONDBRANCH,ALLOT_0001

     .word XT_DOLITERAL
     .word 0xFFFFF000
     .word XT_AND
     
     .word XT_DP
     .word XT_DOLITERAL
     .word 0xFFFFF000
     .word XT_AND

     .word XT_MINUS
     .word XT_DOCONDBRANCH,ALLOT_0002
     .word XT_STDDOTUNLOCK
     .word XT_DP
     .word XT_STDDOTERASE
     STRING "allot:erase"
     .word XT_TYPE , XT_CR
     .word XT_FINISH
ALLOT_0001:
     .word XT_DROP
ALLOT_0002:     
     .word XT_EXIT

# ----------------------------------------------------------------------
.else
COLON "allot", ALLOT 
	.word XT_DP
	.word XT_PLUS
	.word XT_DUP
	.word XT_DOLITERAL
	.word 0xff
	.word XT_AND
	.word XT_ZEROEQUAL
	.word XT_DOCONDBRANCH,ALLOT_0001 # if
#	.word XT_TOFLUSHLAST
ALLOT_0001: # then
	.word XT_DOTO , XT_DP
	.word XT_EXIT
.endif
