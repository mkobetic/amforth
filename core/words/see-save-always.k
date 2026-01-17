# SPDX-License-Identifier: GPL-3.0-only
# transpiling match.f on 2024/03/24 09:24:03
# 
# variable see.lfa
# variable see.ip
# variable see.done?
# 
# : see.ip++ cell see.ip +! ;
# : see.line see.ip @ hex. see.ip @ @ hex. ;
# 
# : see.any? drop true ;
# : see.lfa? see.lfa @ = ;
# : see.ffa? see.lfa @ lfa>ffa = ;
# : see.nfa? see.lfa @ lfa>ffa ffa>nfa = ;
# 
# : see.do.lfa see.line s" LFA" type cr see.ip++ ;
# : see.do.ffa see.line s" FFA" type cr see.ip++ ;
# : see.do.nfa
#     see.line s" NFA >> " type
#     see.ip @ count type s"  <<" type cr
# 
#     see.ip @ c@ 1+ aligned 4 / 1-
#     \ dup s" INDEX " type u. cr
# 
#     see.ip++
# 
#     0 ?do see.line s" ..." type cr see.ip++ loop
# ;
# 
# : see.do.lit
#     see.line s" L "    type cr see.ip++
#     see.line s" <----" type cr see.ip++
# ;
# 
# : see.do.slit
#     see.line s" S LITERAL " type cr see.ip++
#     see.line see.ip @ count type cr
#     see.ip @ c@ 1+ aligned 4 / 1-
#     \ dup s" INDEX " type u. cr
# 
#     see.ip++
# 
#     0 ?do see.line s" ..." type cr see.ip++ loop
# ;
# 
# : see.do.xlit
#     see.line s" X LITERAL " type cr see.ip++
#     see.line s" <---- " type
#     see.ip @ @ xt>string type cr
#     see.ip++
# ;
# 
# : see.do.bra
#     see.line s" B "    type cr see.ip++
#     see.line s" <----" type cr see.ip++
# ;
# 
# : see.do.xt
#     see.line see.ip @ @ xt>string type cr see.ip++
# ;
# 
# : see.do.exit
#     see.line s" EXIT " type
#     see.ip @  see.lfa @ - cell + u. s" bytes" type
#     cr
#     true see.done? !
# ;
# 
# : see.do.next
#     see.line s" NEXT " type
#     see.ip @  see.lfa @ - cell + u. s" bytes" type
#     cr
#     true see.done? !
# ;
# 
# : see.do.colon see.line s" COLON" type cr see.ip++ ;
# : see.do.codeword see.line s" CODEWORD" type cr see.ip++ ;
# : see.do.asm see.line see.ip @ dis.asm cr see.ip++ ;
# 
# : see.colon \# ( xt -- ) SEE: deconstruct a colon word (subword of see)
#     xt>lfa dup see.ip ! see.lfa !
#     false see.done? !
# 
#     begin
#         see.ip @ match
#             ['] see.lfa?  act see.do.lfa end
#             ['] see.ffa?  act see.do.ffa end
#             ['] see.nfa?  act see.do.nfa end
# 
#             ['] colon?     act see.do.colon end
#             ['] literal?   act see.do.lit end
#             ['] xliteral?  act see.do.xlit end
#             ['] sliteral?  act see.do.slit end
#             ['] anybranch? act see.do.bra end
#             ['] exit?      act see.do.exit end
# 
#             ['] see.any?  act see.do.xt end
#         endmatch
# 
#     see.done? @ until
# 
# ;
# 
# : see.codeword \# ( xt -- ) SEE: deconstruct a codeword (subword of see)
#     xt>lfa dup see.ip ! see.lfa !
#     false see.done? !
# 
#     begin
#         see.ip @ match
#             ['] see.lfa?  act see.do.lfa end
#             ['] see.ffa?  act see.do.ffa end
#             ['] see.nfa?  act see.do.nfa end
#             ['] codeword?  act see.do.codeword end
#             ['] next?      act see.do.next end
#             \ ['] see.any?  act see.line cr see.ip++ end
#             ['] see.any?  act see.do.asm end
#         endmatch
#     see.done? @ until
# ;
# 
# : see.variable \# ( xt -- ) SEE: deconstruct a variable (subword of see)
#     >r
#     r@ xt>string type cr
#     r@ hex. r@ @ hex. s" VARIABLE" type cr
#     r@ cell+
#     dup    hex.    \ PFA --
#     @ hex.
#     cr
#     rdrop
# ;
# 
# : see.value \# ( xt -- ) SEE: deconstruct value (subword of see)
#     >r
#     r@ xt>string type cr
#     r@ hex. r@ @ hex. s" VALUE" type cr
#     r@ cell+
#     dup    hex.    \ PFA --
#     @ hex.
#     cr
#     rdrop
# ;
# 
# : see \# ( "name" ) SEE: deconstruct word "name"
# 
#     REGITC dis.regname !
# 
#     parse-name find-xt if
#         dup colon?    if see.colon    exit then
#         dup codeword? if see.codeword exit then
#         dup variable? if see.variable exit then
#         dup value?    if see.value    exit then
#         drop
#     else
#         s" name not found" type cr
#     then
# ;

VARIABLE "see.lfa", SEEDOTLFA
	.word XT_SEEDOTLFA
VARIABLE "see.ip", SEEDOTIP
	.word XT_SEEDOTIP
VARIABLE "see.done?", SEEDOTDONEQ
	.word XT_SEEDOTDONEQ
# ----------------------------------------------------------------------
COLON "see.ip++", SEEDOTIPPLUSPLUS 
	.word XT_CELL
	.word XT_SEEDOTIP
	.word XT_PLUSSTORE
	.word XT_EXIT
# ----------------------------------------------------------------------
COLON "see.line", SEEDOTLINE 
	.word XT_SEEDOTIP
	.word XT_FETCH
	.word XT_HEXDOT
	.word XT_SEEDOTIP
	.word XT_FETCH
	.word XT_FETCH
	.word XT_HEXDOT
	.word XT_EXIT
# ----------------------------------------------------------------------
COLON "see.any?", SEEDOTANYQ 
	.word XT_DROP
	.word XT_TRUE
	.word XT_EXIT
# ----------------------------------------------------------------------
COLON "see.lfa?", SEEDOTLFAQ 
	.word XT_SEEDOTLFA
	.word XT_FETCH
	.word XT_EQUAL
	.word XT_EXIT
# ----------------------------------------------------------------------
COLON "see.ffa?", SEEDOTFFAQ 
	.word XT_SEEDOTLFA
	.word XT_FETCH
	.word XT_LFA2FFA
	.word XT_EQUAL
	.word XT_EXIT
# ----------------------------------------------------------------------
COLON "see.nfa?", SEEDOTNFAQ 
	.word XT_SEEDOTLFA
	.word XT_FETCH
	.word XT_LFA2FFA
	.word XT_FFA2NFA
	.word XT_EQUAL
	.word XT_EXIT
# ----------------------------------------------------------------------
COLON "see.do.lfa", SEEDOTDODOTLFA 
	.word XT_SEEDOTLINE
	STRING "LFA"
	.word XT_TYPE
	.word XT_CR
	.word XT_SEEDOTIPPLUSPLUS
	.word XT_EXIT
# ----------------------------------------------------------------------
COLON "see.do.ffa", SEEDOTDODOTFFA 
	.word XT_SEEDOTLINE
	STRING "FFA"
	.word XT_TYPE
	.word XT_CR
	.word XT_SEEDOTIPPLUSPLUS
	.word XT_EXIT
# ----------------------------------------------------------------------
COLON "see.do.nfa", SEEDOTDODOTNFA 
	.word XT_SEEDOTLINE
	STRING "NFA >> "
	.word XT_TYPE
	.word XT_SEEDOTIP
	.word XT_FETCH
	.word XT_COUNT
	.word XT_TYPE
	STRING " <<"
	.word XT_TYPE
	.word XT_CR
	.word XT_SEEDOTIP
	.word XT_FETCH
	.word XT_CFETCH
	.word XT_1PLUS
	.word XT_ALIGNED
	.word XT_FOUR
	.word XT_SLASH
	.word XT_1MINUS
	.word XT_SEEDOTIPPLUSPLUS
	.word XT_ZERO
	.word XT_QDOCHECK, XT_DOCONDBRANCH,SEEDOTDODOTNFA_0001 # ?do
	.word XT_DODO
SEEDOTDODOTNFA_0002: # do
	.word XT_SEEDOTLINE
	STRING "..."
	.word XT_TYPE
	.word XT_CR
	.word XT_SEEDOTIPPLUSPLUS
	.word XT_DOLOOP,SEEDOTDODOTNFA_0002 # loop
SEEDOTDODOTNFA_0001: # (for ?do IF required) 
	.word XT_EXIT
# ----------------------------------------------------------------------
COLON "see.do.lit", SEEDOTDODOTLIT 
	.word XT_SEEDOTLINE
	STRING "L "
	.word XT_TYPE
	.word XT_CR
	.word XT_SEEDOTIPPLUSPLUS
	.word XT_SEEDOTLINE
	STRING "<----"
	.word XT_TYPE
	.word XT_CR
	.word XT_SEEDOTIPPLUSPLUS
	.word XT_EXIT
# ----------------------------------------------------------------------
COLON "see.do.slit", SEEDOTDODOTSLIT 
	.word XT_SEEDOTLINE
	STRING "S LITERAL "
	.word XT_TYPE
	.word XT_CR
	.word XT_SEEDOTIPPLUSPLUS
	.word XT_SEEDOTLINE
	.word XT_SEEDOTIP
	.word XT_FETCH
	.word XT_COUNT
	.word XT_TYPE
	.word XT_CR
	.word XT_SEEDOTIP
	.word XT_FETCH
	.word XT_CFETCH
	.word XT_1PLUS
	.word XT_ALIGNED
	.word XT_FOUR
	.word XT_SLASH
	.word XT_1MINUS
	.word XT_SEEDOTIPPLUSPLUS
	.word XT_ZERO
	.word XT_QDOCHECK, XT_DOCONDBRANCH,SEEDOTDODOTSLIT_0001 # ?do
	.word XT_DODO
SEEDOTDODOTSLIT_0002: # do
	.word XT_SEEDOTLINE
	STRING "..."
	.word XT_TYPE
	.word XT_CR
	.word XT_SEEDOTIPPLUSPLUS
	.word XT_DOLOOP,SEEDOTDODOTSLIT_0002 # loop
SEEDOTDODOTSLIT_0001: # (for ?do IF required) 
	.word XT_EXIT
# ----------------------------------------------------------------------
COLON "see.do.xlit", SEEDOTDODOTXLIT 
	.word XT_SEEDOTLINE
	STRING "X LITERAL "
	.word XT_TYPE
	.word XT_CR
	.word XT_SEEDOTIPPLUSPLUS
	.word XT_SEEDOTLINE
	STRING "<---- "
	.word XT_TYPE
	.word XT_SEEDOTIP
	.word XT_FETCH
	.word XT_FETCH
	.word XT_XT2STRING
	.word XT_TYPE
	.word XT_CR
	.word XT_SEEDOTIPPLUSPLUS
	.word XT_EXIT
# ----------------------------------------------------------------------
COLON "see.do.bra", SEEDOTDODOTBRA 
	.word XT_SEEDOTLINE
	STRING "B "
	.word XT_TYPE
	.word XT_CR
	.word XT_SEEDOTIPPLUSPLUS
	.word XT_SEEDOTLINE
	STRING "<----"
	.word XT_TYPE
	.word XT_CR
	.word XT_SEEDOTIPPLUSPLUS
	.word XT_EXIT
# ----------------------------------------------------------------------
COLON "see.do.xt", SEEDOTDODOTXT 
	.word XT_SEEDOTLINE
	.word XT_SEEDOTIP
	.word XT_FETCH
	.word XT_FETCH
	.word XT_XT2STRING
	.word XT_TYPE
	.word XT_CR
	.word XT_SEEDOTIPPLUSPLUS
	.word XT_EXIT
# ----------------------------------------------------------------------
COLON "see.do.exit", SEEDOTDODOTEXIT 
	.word XT_SEEDOTLINE
	STRING "EXIT "
	.word XT_TYPE
	.word XT_SEEDOTIP
	.word XT_FETCH
	.word XT_SEEDOTLFA
	.word XT_FETCH
	.word XT_MINUS
	.word XT_CELL
	.word XT_PLUS
	.word XT_UDOT
	STRING "bytes"
	.word XT_TYPE
	.word XT_CR
	.word XT_TRUE
	.word XT_SEEDOTDONEQ
	.word XT_STORE
	.word XT_EXIT
# ----------------------------------------------------------------------
COLON "see.do.next", SEEDOTDODOTNEXT 
	.word XT_SEEDOTLINE
	STRING "NEXT "
	.word XT_TYPE
	.word XT_SEEDOTIP
	.word XT_FETCH
	.word XT_SEEDOTLFA
	.word XT_FETCH
	.word XT_MINUS
	.word XT_CELL
	.word XT_PLUS
	.word XT_UDOT
	STRING "bytes"
	.word XT_TYPE
	.word XT_CR
	.word XT_TRUE
	.word XT_SEEDOTDONEQ
	.word XT_STORE
	.word XT_EXIT
# ----------------------------------------------------------------------
COLON "see.do.colon", SEEDOTDODOTCOLON 
	.word XT_SEEDOTLINE
	STRING "COLON"
	.word XT_TYPE
	.word XT_CR
	.word XT_SEEDOTIPPLUSPLUS
	.word XT_EXIT
# ----------------------------------------------------------------------
COLON "see.do.codeword", SEEDOTDODOTCODEWORD 
	.word XT_SEEDOTLINE
	STRING "CODEWORD"
	.word XT_TYPE
	.word XT_CR
	.word XT_SEEDOTIPPLUSPLUS
	.word XT_EXIT
# ----------------------------------------------------------------------
COLON "see.do.asm", SEEDOTDODOTASM 
	.word XT_SEEDOTLINE
	.word XT_SEEDOTIP
	.word XT_FETCH
	.word XT_DISDOTASM
	.word XT_CR
	.word XT_SEEDOTIPPLUSPLUS
	.word XT_EXIT
# ----------------------------------------------------------------------
COLON "see.colon", SEEDOTCOLON # ( xt -- ) SEE: deconstruct a colon word (subword of see) 
	.word XT_XTGTLFA
	.word XT_DUP
	.word XT_SEEDOTIP
	.word XT_STORE
	.word XT_SEEDOTLFA
	.word XT_STORE
	.word XT_FALSE
	.word XT_SEEDOTDONEQ
	.word XT_STORE
SEEDOTCOLON_0001: # begin
	.word XT_SEEDOTIP
	.word XT_FETCH
	.word XT_DOLITERAL
	.word XT_SEEDOTLFAQ
	.word XT_OVER
	.word XT_SWAP
	.word XT_EXECUTE
	.word XT_DOCONDBRANCH,SEEDOTCOLON_0002 # if
	.word XT_DROP
	.word XT_SEEDOTDODOTLFA
	.word XT_DOBRANCH,SEEDOTCOLON_0003
SEEDOTCOLON_0002: # else
	.word XT_DOLITERAL
	.word XT_SEEDOTFFAQ
	.word XT_OVER
	.word XT_SWAP
	.word XT_EXECUTE
	.word XT_DOCONDBRANCH,SEEDOTCOLON_0004 # if
	.word XT_DROP
	.word XT_SEEDOTDODOTFFA
	.word XT_DOBRANCH,SEEDOTCOLON_0005
SEEDOTCOLON_0004: # else
	.word XT_DOLITERAL
	.word XT_SEEDOTNFAQ
	.word XT_OVER
	.word XT_SWAP
	.word XT_EXECUTE
	.word XT_DOCONDBRANCH,SEEDOTCOLON_0006 # if
	.word XT_DROP
	.word XT_SEEDOTDODOTNFA
	.word XT_DOBRANCH,SEEDOTCOLON_0007
SEEDOTCOLON_0006: # else
	.word XT_DOLITERAL
	.word XT_COLONQ
	.word XT_OVER
	.word XT_SWAP
	.word XT_EXECUTE
	.word XT_DOCONDBRANCH,SEEDOTCOLON_0008 # if
	.word XT_DROP
	.word XT_SEEDOTDODOTCOLON
	.word XT_DOBRANCH,SEEDOTCOLON_0009
SEEDOTCOLON_0008: # else
	.word XT_DOLITERAL
	.word XT_LITERALQ
	.word XT_OVER
	.word XT_SWAP
	.word XT_EXECUTE
	.word XT_DOCONDBRANCH,SEEDOTCOLON_000A # if
	.word XT_DROP
	.word XT_SEEDOTDODOTLIT
	.word XT_DOBRANCH,SEEDOTCOLON_000B
SEEDOTCOLON_000A: # else
	.word XT_DOLITERAL
	.word XT_XLITERALQ
	.word XT_OVER
	.word XT_SWAP
	.word XT_EXECUTE
	.word XT_DOCONDBRANCH,SEEDOTCOLON_000C # if
	.word XT_DROP
	.word XT_SEEDOTDODOTXLIT
	.word XT_DOBRANCH,SEEDOTCOLON_000D
SEEDOTCOLON_000C: # else
	.word XT_DOLITERAL
	.word XT_SLITERALQ
	.word XT_OVER
	.word XT_SWAP
	.word XT_EXECUTE
	.word XT_DOCONDBRANCH,SEEDOTCOLON_000E # if
	.word XT_DROP
	.word XT_SEEDOTDODOTSLIT
	.word XT_DOBRANCH,SEEDOTCOLON_000F
SEEDOTCOLON_000E: # else
	.word XT_DOLITERAL
	.word XT_ANYBRANCHQ
	.word XT_OVER
	.word XT_SWAP
	.word XT_EXECUTE
	.word XT_DOCONDBRANCH,SEEDOTCOLON_0010 # if
	.word XT_DROP
	.word XT_SEEDOTDODOTBRA
	.word XT_DOBRANCH,SEEDOTCOLON_0011
SEEDOTCOLON_0010: # else
	.word XT_DOLITERAL
	.word XT_EXITQ
	.word XT_OVER
	.word XT_SWAP
	.word XT_EXECUTE
	.word XT_DOCONDBRANCH,SEEDOTCOLON_0012 # if
	.word XT_DROP
	.word XT_SEEDOTDODOTEXIT
	.word XT_DOBRANCH,SEEDOTCOLON_0013
SEEDOTCOLON_0012: # else
	.word XT_DOLITERAL
	.word XT_SEEDOTANYQ
	.word XT_OVER
	.word XT_SWAP
	.word XT_EXECUTE
	.word XT_DOCONDBRANCH,SEEDOTCOLON_0014 # if
	.word XT_DROP
	.word XT_SEEDOTDODOTXT
	.word XT_DOBRANCH,SEEDOTCOLON_0015
SEEDOTCOLON_0014: # else
	.word XT_DROP
SEEDOTCOLON_0015: # then
SEEDOTCOLON_0013: # then
SEEDOTCOLON_0011: # then
SEEDOTCOLON_000F: # then
SEEDOTCOLON_000D: # then
SEEDOTCOLON_000B: # then
SEEDOTCOLON_0009: # then
SEEDOTCOLON_0007: # then
SEEDOTCOLON_0005: # then
SEEDOTCOLON_0003: # then
	.word XT_SEEDOTDONEQ
	.word XT_FETCH
	.word XT_DOCONDBRANCH,SEEDOTCOLON_0001 # until
	.word XT_EXIT
# ----------------------------------------------------------------------
COLON "see.codeword", SEEDOTCODEWORD # ( xt -- ) SEE: deconstruct a codeword (subword of see) 
	.word XT_XTGTLFA
	.word XT_DUP
	.word XT_SEEDOTIP
	.word XT_STORE
	.word XT_SEEDOTLFA
	.word XT_STORE
	.word XT_FALSE
	.word XT_SEEDOTDONEQ
	.word XT_STORE
SEEDOTCODEWORD_0001: # begin
	.word XT_SEEDOTIP
	.word XT_FETCH
	.word XT_DOLITERAL
	.word XT_SEEDOTLFAQ
	.word XT_OVER
	.word XT_SWAP
	.word XT_EXECUTE
	.word XT_DOCONDBRANCH,SEEDOTCODEWORD_0002 # if
	.word XT_DROP
	.word XT_SEEDOTDODOTLFA
	.word XT_DOBRANCH,SEEDOTCODEWORD_0003
SEEDOTCODEWORD_0002: # else
	.word XT_DOLITERAL
	.word XT_SEEDOTFFAQ
	.word XT_OVER
	.word XT_SWAP
	.word XT_EXECUTE
	.word XT_DOCONDBRANCH,SEEDOTCODEWORD_0004 # if
	.word XT_DROP
	.word XT_SEEDOTDODOTFFA
	.word XT_DOBRANCH,SEEDOTCODEWORD_0005
SEEDOTCODEWORD_0004: # else
	.word XT_DOLITERAL
	.word XT_SEEDOTNFAQ
	.word XT_OVER
	.word XT_SWAP
	.word XT_EXECUTE
	.word XT_DOCONDBRANCH,SEEDOTCODEWORD_0006 # if
	.word XT_DROP
	.word XT_SEEDOTDODOTNFA
	.word XT_DOBRANCH,SEEDOTCODEWORD_0007
SEEDOTCODEWORD_0006: # else
	.word XT_DOLITERAL
	.word XT_CODEWORDQ
	.word XT_OVER
	.word XT_SWAP
	.word XT_EXECUTE
	.word XT_DOCONDBRANCH,SEEDOTCODEWORD_0008 # if
	.word XT_DROP
	.word XT_SEEDOTDODOTCODEWORD
	.word XT_DOBRANCH,SEEDOTCODEWORD_0009
SEEDOTCODEWORD_0008: # else
	.word XT_DOLITERAL
	.word XT_NEXTQ
	.word XT_OVER
	.word XT_SWAP
	.word XT_EXECUTE
	.word XT_DOCONDBRANCH,SEEDOTCODEWORD_000A # if
	.word XT_DROP
	.word XT_SEEDOTDODOTNEXT
	.word XT_DOBRANCH,SEEDOTCODEWORD_000B
SEEDOTCODEWORD_000A: # else
	.word XT_DOLITERAL
	.word XT_SEEDOTANYQ
	.word XT_OVER
	.word XT_SWAP
	.word XT_EXECUTE
	.word XT_DOCONDBRANCH,SEEDOTCODEWORD_000C # if
	.word XT_DROP
	.word XT_SEEDOTDODOTASM
	.word XT_DOBRANCH,SEEDOTCODEWORD_000D
SEEDOTCODEWORD_000C: # else
	.word XT_DROP
SEEDOTCODEWORD_000D: # then
SEEDOTCODEWORD_000B: # then
SEEDOTCODEWORD_0009: # then
SEEDOTCODEWORD_0007: # then
SEEDOTCODEWORD_0005: # then
SEEDOTCODEWORD_0003: # then
	.word XT_SEEDOTDONEQ
	.word XT_FETCH
	.word XT_DOCONDBRANCH,SEEDOTCODEWORD_0001 # until
	.word XT_EXIT
# ----------------------------------------------------------------------
COLON "see.variable", SEEDOTVARIABLE # ( xt -- ) SEE: deconstruct a variable (subword of see) 
	.word XT_TO_R
	.word XT_R_FETCH
	.word XT_XT2STRING
	.word XT_TYPE
	.word XT_CR
	.word XT_R_FETCH
	.word XT_HEXDOT
	.word XT_R_FETCH
	.word XT_FETCH
	.word XT_HEXDOT
	STRING "VARIABLE"
	.word XT_TYPE
	.word XT_CR
	.word XT_R_FETCH
	.word XT_CELLPLUS
	.word XT_DUP
	.word XT_HEXDOT
	.word XT_FETCH
	.word XT_HEXDOT
	.word XT_CR
	.word XT_RDROP
	.word XT_EXIT
# ----------------------------------------------------------------------
COLON "see.value", SEEDOTVALUE # ( xt -- ) SEE: deconstruct value (subword of see) 
	.word XT_TO_R
	.word XT_R_FETCH
	.word XT_XT2STRING
	.word XT_TYPE
	.word XT_CR
	.word XT_R_FETCH
	.word XT_HEXDOT
	.word XT_R_FETCH
	.word XT_FETCH
	.word XT_HEXDOT
	STRING "VALUE"
	.word XT_TYPE
	.word XT_CR
	.word XT_R_FETCH
	.word XT_CELLPLUS
	.word XT_DUP
	.word XT_HEXDOT
	.word XT_FETCH
	.word XT_HEXDOT
	.word XT_CR
	.word XT_RDROP
	.word XT_EXIT
# ----------------------------------------------------------------------
COLON "see", SEE # ( "name" ) SEE: deconstruct word "name"
	.word XT_CON_REGITC
	.word XT_DISDOTREGNAME
	.word XT_STORE
	.word XT_PARSENAME
	.word XT_FINDXT
	.word XT_DOCONDBRANCH,SEE_0001 # if
	.word XT_DUP
	.word XT_COLONQ
	.word XT_DOCONDBRANCH,SEE_0002 # if
	.word XT_SEEDOTCOLON
	.word XT_FINISH
SEE_0002: # then
	.word XT_DUP
	.word XT_CODEWORDQ
	.word XT_DOCONDBRANCH,SEE_0003 # if
	.word XT_SEEDOTCODEWORD
	.word XT_FINISH
SEE_0003: # then
	.word XT_DUP
	.word XT_VARIABLEQ
	.word XT_DOCONDBRANCH,SEE_0004 # if
	.word XT_SEEDOTVARIABLE
	.word XT_FINISH
SEE_0004: # then
	.word XT_DUP
	.word XT_VALUEQ
	.word XT_DOCONDBRANCH,SEE_0005 # if
	.word XT_SEEDOTVALUE
	.word XT_FINISH
SEE_0005: # then
	.word XT_DROP
	.word XT_DOBRANCH,SEE_0006
SEE_0001: # else
	STRING "name not found"
	.word XT_TYPE
	.word XT_CR
SEE_0006: # then
	.word XT_EXIT
# ----------------------------------------------------------------------
