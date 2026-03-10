#======================================================================
#======================================================================
# transpiling dictopt-newb.f on 2026/03/07 14:01:31
# \ SPDX-License-Identifier: GPL-3.0-only
# 
# : xt>nfa \# ( xt -- nfa ) Given XT find NFA
# 
#  \# .if RA_FLASH == YES
#     \ move to lower address a where [-a] <> 0
#     begin cell- dup @ 0<> until cell+
# \# .endif
# 
#     >r r@
#     begin
#         cell- dup               \ a a        --
#         c@ cell / 1+ cell *     \ a n        --
#         over +                  \ a a'       --
#         r@                      \ a a' a''   --
#         =                       \ a f        --
#         \ a poor check
#         over r@ swap - cr #64 > if 2drop rdrop 0 exit then
#     until
#     rdrop
# ;
# 
# : nfa>xt \# ( nfa -- xt ) Given NFA find XT
#     \ dup c@ cell / 1+ cells + \ a --
#     count + aligned
# 
# \# .if RA_FLASH == YES
#     \ move to higher address a where [a] <> 0
#     begin dup cell+ swap @ 0<> until cell-
# \# .endif
# 
# ;
# 
# : ffa2cfa \# ( ffa -- xt ) Given FFA find XT
#     cell+ nfa>xt
# ;
# 
# : nfa>string \# ( nfa -- c-addr u ) Given NFA leave c-addr u string
#     count
# ;
# 
# : xt>string \# ( xt -- c-addr u ) Given XT leave c-addr u string
#     xt>nfa nfa>string
# ;
# 
# : lfa>ffa \# ( lfa -- ffa ) Given LFA find FFA
#     cell+
# ;
# 
# : ffa>lfa \# ( ffa -- lfa ) Given FFA find LFA
#     cell-
# ;
# 
# : ffa>nfa \# ( ffa -- nfa ) Given FFA find NFA
#     cell+
# ;
# 
# : xt>ffa \# ( xt -- ffa ) Given XT find FFA
#     xt>nfa cell-
# ;
# 
# : ffa>string \# ( ffa -- caddr u ) Given FFA leave c-addr u string
#     cell+ count #255 and
# ;
# 
# : xt>lfa \# ( xt -- lfa ) Given XT find LFA
#     xt>nfa cell- cell-
# ;
# 

# ----------------------------------------------------------------------
COLON "xt>nfa", XT2NFA /* ( xt -- nfa ) Given XT find NFA  */
.if RA_FLASH == YES 
XT2NFA_0001: /* begin */
	.word XT_CELLMINUS
	.word XT_DUP
	.word XT_FETCH
	.word XT_NOTZEROEQUAL
	.word XT_DOCONDBRANCH,XT2NFA_0001 /* until */
	.word XT_CELLPLUS
 .endif      
	.word XT_TO_R
	.word XT_R_FETCH
XT2NFA_0002: /* begin */
	.word XT_CELLMINUS
	.word XT_DUP
	.word XT_CFETCH
	.word XT_CELL
	.word XT_SLASH
	.word XT_1PLUS
	.word XT_CELL
	.word XT_STAR
	.word XT_OVER
	.word XT_PLUS
	.word XT_R_FETCH
	.word XT_EQUAL
	.word XT_OVER
	.word XT_R_FETCH
	.word XT_SWAP
	.word XT_MINUS
	.word XT_DOLITERAL
	.word 64
	.word XT_GREATER
	.word XT_DOCONDBRANCH,XT2NFA_0003 /* if */
	.word XT_2DROP
	.word XT_RDROP
	.word XT_ZERO
	.word XT_FINISH
XT2NFA_0003: /* then */
	.word XT_DOCONDBRANCH,XT2NFA_0002 /* until */
	.word XT_RDROP
	.word XT_EXIT
END XT2NFA
# ----------------------------------------------------------------------
COLON "nfa>xt", NFA2XT /* ( nfa -- xt ) Given NFA find XT */
	.word XT_COUNT
	.word XT_PLUS
	.word XT_ALIGNED
    .word XT_DUP
    .word XT_DROP
.if RA_FLASH == YES
NFA2XT_0001: /* begin */
	.word XT_DUP
	.word XT_CELLPLUS
	.word XT_SWAP
	.word XT_FETCH
	.word XT_NOTZEROEQUAL
	.word XT_DOCONDBRANCH,NFA2XT_0001 /* until */
	.word XT_CELLMINUS
.endif 
	.word XT_EXIT
END NFA2XT
# ----------------------------------------------------------------------
COLON "ffa2cfa", FFA2CFA /* ( ffa -- xt ) Given FFA find XT */
	.word XT_CELLPLUS
	.word XT_NFA2XT
	.word XT_EXIT
END FFA2CFA
# ----------------------------------------------------------------------
COLON "nfa>string", NFA2STRING /* ( nfa -- c-addr u ) Given NFA leave c-addr u string  */
	.word XT_COUNT
	.word XT_EXIT
END NFA2STRING
# ----------------------------------------------------------------------
COLON "xt>string", XT2STRING /* ( xt -- c-addr u ) Given XT leave c-addr u string */
	.word XT_XT2NFA
	.word XT_NFA2STRING
	.word XT_EXIT
END XT2STRING
# ----------------------------------------------------------------------
COLON "lfa>ffa", LFA2FFA /* ( lfa -- ffa ) Given LFA find FFA */
	.word XT_CELLPLUS
	.word XT_EXIT
END LFA2FFA
# ----------------------------------------------------------------------
COLON "ffa>lfa", FFA2LFA /* ( ffa -- lfa ) Given FFA find LFA */
	.word XT_CELLMINUS
	.word XT_EXIT
END FFA2LFA
# ----------------------------------------------------------------------
COLON "ffa>nfa", FFA2NFA /* ( ffa -- nfa ) Given FFA find NFA */
	.word XT_CELLPLUS
	.word XT_EXIT
END FFA2NFA
# ----------------------------------------------------------------------
COLON "xt>ffa", XT2FFA /* ( xt -- ffa ) Given XT find FFA */
	.word XT_XT2NFA
	.word XT_CELLMINUS
	.word XT_EXIT
END XT2FFA
# ----------------------------------------------------------------------
COLON "ffa>string", FFA2STRING /* ( ffa -- caddr u ) Given FFA leave c-addr u string */
	.word XT_CELLPLUS
	.word XT_COUNT
	.word XT_DOLITERAL
	.word 255
	.word XT_AND
	.word XT_EXIT
END FFA2STRING
# ----------------------------------------------------------------------
COLON "xt>lfa", XT2LFA /* ( xt -- lfa ) Given XT find LFA */
	.word XT_XT2NFA
	.word XT_CELLMINUS
	.word XT_CELLMINUS
	.word XT_EXIT
END XT2LFA
# ----------------------------------------------------------------------
#=====================================================================
#======================================================================
