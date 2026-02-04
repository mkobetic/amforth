# SPDX-License-Identifier: GPL-3.0-only

.ifdef FLUSH_REQUIRED

NONAME LBRAFLUSHRBRA 
	.word XT_MEMMODE
	.word XT_DOCONDBRANCH,FLASHDOTFLUSH_0001 /* if */
    .word XT_DPDOTCACHE
#   .word XT_DUP , XT_HEXDOT , XT_CR 
    .word XT_DOCONDBRANCH,FLASHDOTFLUSH_0001 /* if */
	.word XT_FLASHDOTCACHE
	.word XT_DPDOTCACHE
	.word XT_PLUS
	.word XT_FLASHDOTCELL
	.word XT_DPDOTCACHE
	.word XT_MINUS
	.word XT_DUP
	.word XT_TO_R
	.word XT_ZERO
	.word XT_FILL
	.word XT_R_FROM
	.word XT_DALLOT
FLASHDOTFLUSH_0001: /* then */
	.word XT_EXIT

.endif

COLON "flush", FLUSH /* ( -- ) force flush (write) of flash.cache */
.ifdef FLUSH_REQUIRED
    .word XT_LBRAFLUSHRBRA
.endif
    .word XT_EXIT


#COLON "flash.flush", FLASHDOTFLUSH /* ( -- ) force flush (write) of flash.cache */
NONAME FLASHDOTFLUSH                /* ( -- ) force flush (write) of flash.cache */
.ifdef FLUSH_REQUIRED
    .word XT_LBRAFLUSHRBRA 
.endif
    .word XT_EXIT
