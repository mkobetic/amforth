# SPDX-License-Identifier: GPL-3.0-only

#NONAME GMARK
#COLON "gmark",  GMARK
#    .word XT_DP
#    .word XT_COMPILE
#    .space 4 
#    .word -1
#    .word XT_EXIT
    


COLON "gmark", GMARK
.ifdef RA_FLASH
	.word XT_MEMMODE
	.word XT_DOCONDBRANCH,GMARK_0001 /* if */
	.word XT_DP
	.word XT_DUP
    .word XT_FLASHDOTCELL
    .word XT_PLUS
    .word XT_DOTO
	.word XT_DP
	.word XT_DOBRANCH,GMARK_0002
GMARK_0001: /* else */
.endif 
    .word XT_DP
    .word XT_COMPILE
    .space 4 
#   .word -1
GMARK_0002: /* # then */
	.word XT_EXIT
END GMARK
