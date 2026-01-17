# SPDX-License-Identifier: GPL-3.0-only
#======================================================================
#======================================================================
# transpiling User/fth-words/dis-asm.f on 2024/05/30 10:10:11
# 
# : xt>lfa ( xt -- lfa ) xt>nfa cell- cell- ;
# : header? ( a xt -- f ) cell+ swap u> ;
# 
# : next? \# ( a -- f ) DICT: f true if a contains XT of NEXT
#     >r
# \    r@ @ $FFF and $06f = invert if rdrop false exit then
#     r@ @ #12 ashift 2* $FFF00000 and
#     r@ @ $7FE00000 and #20 rshift or
#     r@ @ $100000 and #9 rshift or
#     r@ @ $FF000 and or
#     r@ + XT.DONEXT =
#     r> @ $fffff and $28067 =  \ jalr x0, 0(t0) is $28067
#     or                        \ so code...;code works
# ;
# 
# \ see.forth
# \ this needs an AWFUL lot of cleaning up
# 
# $7f    constant dis.op.mask
# $f80   constant dis.rd.mask
# $7000  constant dis.fn3.mask
# $f8000 constant dis.rs1.mask
# %11111111111100000000000000000000 constant dis.imm_i.mask
# 
# variable dis.op
# variable dis.rd
# variable dis.rs1
# variable dis.rs2
# variable dis.fn3
# variable dis.fn7
# variable dis.imm_i
# variable dis.imm_j
# variable dis.imm_s
# variable dis.imm_b
# variable dis.imm_u
# variable dis.regname
# 
# : dis.num REGNUM dis.regname ! ;
# : dis.abi REGABI dis.regname ! ;
# : dis.itc REGITC dis.regname ! ;
# 
# : dis.,> s"  , " type ;
# : dis.(> [char] ( emit ;
# : dis.)> [char] ) emit ;
# 
# : dis.reg> ( n -- )
#     dis.regname @ swap #31 and cells + dup c@ swap 1+ swap type
# ;
# 
# : dis.asm ( pfa -- )
#     >r
#     r@ @ dis.op.mask and              dis.op     ! \ opcode
#     r@ @ dis.rd.mask and  #07 rshift dis.rd      ! \ rd
#     r@ @ dis.fn3.mask and #12 rshift dis.fn3     ! \ fn3
#     r@ @ dis.rs1.mask and #15 rshift dis.rs1     ! \ rs1
#     r@ @ dis.imm_i.mask and #20 ashift dis.imm_i ! \ imm_i
#     r@ @ $fe000000 and #25 rshift dis.fn7        ! \ fn7
# 
#     r@ @ $FE000000 and #20 ashift
#     r@ @ $f80 and #7 rshift or dis.imm_s !
# 
#     r@ @ %1111100000000000000000000 and #20 rshift dis.rs2 !
# 
#     \ working towards imm_b
# 
#     r@ @ $80000000 and #19 ashift
#     r@ @ $7e000000 and #20 rshift or
#     r@ @ %10000000 and 4 lshift or
#     r@ @ %111100000000 and 7 rshift or dis.imm_b !
# 
#     \ working towards imm_j
# 
#     r@ @ #12 ashift 2* $FFF00000 and
#     r@ @ $7FE00000 and #20 rshift or
#     r@ @ $100000 and #9 rshift or
#     r@ @ $FF000 and or dis.imm_j !
# 
#     \ working towards imm_u
#     r@ @ %11111111111111111111000000000000 and dis.imm_u !
# 
#     \ op=$3 load ==================================================
# 
#     dis.op @ $3 = if
#         dis.fn3 @ 0 = if s" lb    " type then
#         dis.fn3 @ 1 = if s" lh    " type then
#         dis.fn3 @ 2 = if s" lw    " type then
#         dis.fn3 @ 4 = if s" lbu   " type then
#         dis.fn3 @ 5 = if s" lhu   " type then
# 
#         \ s" x" type dis.rd @ x. s" , " type dis.imm_i @ x.
#         \ s" (x" type dis.rs1 @ x. s" )" type
# 
#         dis.rd @ dis.reg> dis.,> dis.imm_i @ x. dis.(> dis.rs1 @ dis.reg> dis.)>
# 
#         rdrop exit
#     then
# 
#     \ op=$33 add  ==================================================
#     \ this can be done better with
#     \                             fn7....fn3
#     \                             6543210210
#     \ dis.fn7 @ dis.fn3 @ or dup %xxxxxxxxxx = if s"...." type then
#     \                        dup %yyyyyyyyyy = if s"...." type then
#     \                        dup %zzzzzzzzzz = if s"...." type then
#     \ go inside dis.op @ $33 = if
#     dis.op @ $33 = if
#         dis.fn7 @ 3 lshift dis.fn3 @ or
#         \    fn7....fn3
#         \    6543210210
#         dup %0000001000 = if s" mul   "  type then
#         dup %0000001001 = if s" mulh  "  type then
#         dup %0000001010 = if s" mulhsu " type then
#         dup %0000001011 = if s" mulhu "  type then
#         dup %0000001100 = if s" div   "  type then
#         dup %0000001101 = if s" divu  "  type then
#         dup %0000001110 = if s" rem   "  type then
#         dup %0000001111 = if s" remu  "  type then
#         \    fn7....fn3
#         \    6543210210
#         dup %0000000000 = if s" add   "  type then
#         dup %0100000000 = if s" sub   "  type then
#         \    fn7....fn3
#         \    6543210210
#         dup %0000000001 = if s" sll   "  type then
#         dup %0000000010 = if s" slt   "  type then
#         dup %0000000011 = if s" sltu  "  type then
#         dup %0000000100 = if s" xor   "  type then
#         dup %0000000101 = if s" srl   "  type then
#         dup %0100000101 = if s" sra   "  type then
#         dup %0000000110 = if s" or    "  type then
#             %0000000111 = if s" and   "  type then
# 
#         dis.rd  @ dis.reg> dis.,>
#         dis.rs1 @ dis.reg> dis.,>
#         dis.rs2 @ dis.reg>
# 
#         rdrop exit
#     then
# 
#     \ op=$13 addi xori ori etc. group=I ~DONE ======================
#     dis.op @ $13 = if
#         dis.fn3 @ 0 = if s" addi  " type then
#         dis.fn3 @ 4 = if s" xori  " type then
#         dis.fn3 @ 6 = if s" ori   " type then
#         dis.fn3 @ 7 = if s" andi  " type then
#         dis.fn3 @ 1 = if s" slli  " type then
#         dis.fn3 @ 5 = if s" srxi  " type then
#         dis.fn3 @ 2 = if s" slti  " type then  \ need check for l/r
#         dis.fn3 @ 3 = if s" sltiu " type then
# 
#         \ s" x" type dis.rd @ x. s" , x" type dis.rs1 @ x.
#         \ s" , " type dis.imm_i @ x.
# 
#         dis.rd @ dis.reg> dis.,> dis.rs1 @ dis.reg> dis.,> dis.imm_i @ x.
# 
#         rdrop exit
#     then
# 
#     \ op=$23 sb sh sw  ~DONE========================================
#     dis.op @ $23 = if
#         dis.fn3 @ 0 = if s" sb    " type then
#         dis.fn3 @ 1 = if s" sh    " type then
#         dis.fn3 @ 2 = if s" sw    " type then
#         \ s" x" type dis.rs2 @ x. s" , " type dis.imm_s @ x.
#         \ s" (x" type dis.rs1 @ x. s" )" type
# 
#         dis.rs2 @ dis.reg> dis.,> dis.imm_s @ x. dis.(> dis.rs1 @ dis.reg> dis.)>
#         rdrop exit
#     then
# 
#     \ op=$63 add  ==================================================
#     dis.op @ $63 = if
#         dis.fn3 @ 0 = if s" beq   " type then
#         dis.fn3 @ 1 = if s" bne   " type then
#         dis.fn3 @ 4 = if s" blt   " type then
#         dis.fn3 @ 5 = if s" bge   " type then
#         dis.fn3 @ 6 = if s" bltu  " type then
#         dis.fn3 @ 7 = if s" bgeu  " type then
#         \ s" x" type dis.rs1 @ x. s" , x" type dis.rs2 @ x.
#         \ s" , " type dis.imm_b @ x.
#         dis.rs1 @ dis.reg> dis.,> dis.rs2 @ dis.reg> dis.,> dis.imm_b @ x.
#     then
# 
#     \ op=$6F add  ==================================================
#     dis.op @ $6F = if
#         s" jal   " type
#         dis.rd @ dis.reg> dis.,> dis.imm_j @ x.
#         space dis.(> dis.imm_j @ r@ + dup 8x. dis.)>
#         XT.DONEXT = if s"  NEXT" type then
#     then
# 
#     \ op=$67 add  ==================================================
#     dis.op @ $67 = if
#         s" jalr  " type
#         dis.rd @ dis.reg> dis.,> dis.rs1 @ dis.reg> dis.,> dis.imm_i @ x.
#         \ wrong dis.rd @ dis.reg> dis.,> dis.imm_i @ x. dis.(> dis.rs1 @ dis.reg> dis.)>
#     then
# 
#     \ op=$37 add  ==================================================
#     dis.op @ $37 = if
#         s" lui   " type
#         dis.rd @ dis.reg> dis.,> dis.imm_u @ 8x.
#     then
# 
#     \ op=$37 add  ==================================================
#     dis.op @ $17 = if
#         s" auipc " type
#         dis.rd @ dis.reg> dis.,> dis.imm_u @ #12 ashift .
# \        s" I auipc (op) (rd) (rs1) (imm_i) " type
# \        dis.op    @ u.
# \        dis.rd    @ u.
# \        dis.rs1   @ u.
#     then
# 
#     rdrop
# ;
# 
# 
# : dis.dump ( a n -- )
#     1+ over swap       \ a a n
#     cells + swap       \ aH aL
#     ?do
#         i hex. i dis.asm cr
#     cell +loop
# ;

# ----------------------------------------------------------------------
COLON "xt>lfa", XTGTLFA 
	.word XT_XT2NFA
	.word XT_CELLMINUS
	.word XT_CELLMINUS
	.word XT_EXIT
# ----------------------------------------------------------------------
COLON "header?", HEADERQ 
	.word XT_CELLPLUS
	.word XT_SWAP
	.word XT_UGREATER
	.word XT_EXIT
# ----------------------------------------------------------------------
COLON "next?", NEXTQ # ( a -- f ) DICT: f true if a contains XT of NEXT 
	.word XT_TO_R
	.word XT_R_FETCH
	.word XT_FETCH
	.word XT_DOLITERAL
	.word 12
	.word XT_ASHIFT
	.word XT_2STAR
	.word XT_DOLITERAL
	.word 0xfff00000
	.word XT_AND
	.word XT_R_FETCH
	.word XT_FETCH
	.word XT_DOLITERAL
	.word 0x7fe00000
	.word XT_AND
	.word XT_DOLITERAL
	.word 20
	.word XT_RSHIFT
	.word XT_OR
	.word XT_R_FETCH
	.word XT_FETCH
	.word XT_DOLITERAL
	.word 0x100000
	.word XT_AND
	.word XT_DOLITERAL
	.word 9
	.word XT_RSHIFT
	.word XT_OR
	.word XT_R_FETCH
	.word XT_FETCH
	.word XT_DOLITERAL
	.word 0xff000
	.word XT_AND
	.word XT_OR
	.word XT_R_FETCH
	.word XT_PLUS
	.word XT_CON_DONEXT
	.word XT_EQUAL
	.word XT_R_FROM
	.word XT_FETCH
	.word XT_DOLITERAL
	.word 0xfffff
	.word XT_AND
	.word XT_DOLITERAL
	.word 0x28067
	.word XT_EQUAL
	.word XT_OR
	.word XT_EXIT
# ----------------------------------------------------------------------
CONSTANT "dis.op.mask",DISDOTOPDOTMASK,0x7f
CONSTANT "dis.rd.mask",DISDOTRDDOTMASK,0xf80
CONSTANT "dis.fn3.mask",DISDOTFN3DOTMASK,0x7000
CONSTANT "dis.rs1.mask",DISDOTRS1DOTMASK,0xf8000
CONSTANT "dis.imm_i.mask",DISDOTIMMUNDERIDOTMASK,0b11111111111100000000000000000000
VARIABLE "dis.op",DISDOTOP
VARIABLE "dis.rd",DISDOTRD
VARIABLE "dis.rs1",DISDOTRS1
VARIABLE "dis.rs2",DISDOTRS2
VARIABLE "dis.fn3",DISDOTFN3
VARIABLE "dis.fn7",DISDOTFN7
VARIABLE "dis.imm_i",DISDOTIMMUNDERI
VARIABLE "dis.imm_j",DISDOTIMMUNDERJ
VARIABLE "dis.imm_s",DISDOTIMMUNDERS
VARIABLE "dis.imm_b",DISDOTIMMUNDERB
VARIABLE "dis.imm_u",DISDOTIMMUNDERU
VARIABLE "dis.regname",DISDOTREGNAME
# ----------------------------------------------------------------------
COLON "dis.num", DISDOTNUM 
	.word XT_CON_REGNUM
	.word XT_DISDOTREGNAME
	.word XT_STORE
	.word XT_EXIT
# ----------------------------------------------------------------------
COLON "dis.abi", DISDOTABI 
	.word XT_CON_REGABI
	.word XT_DISDOTREGNAME
	.word XT_STORE
	.word XT_EXIT
# ----------------------------------------------------------------------
COLON "dis.itc", DISDOTITC 
	.word XT_CON_REGITC
	.word XT_DISDOTREGNAME
	.word XT_STORE
	.word XT_EXIT
# ----------------------------------------------------------------------
COLON "dis.,>", DISDOTCOMMAGT 
	STRING " , "
	.word XT_TYPE
	.word XT_EXIT
# ----------------------------------------------------------------------
COLON "dis.(>", DISDOTLPARENGT 
	.word XT_DOLITERAL # [char]
	.word 40 # (
	.word XT_EMIT
	.word XT_EXIT
# ----------------------------------------------------------------------
COLON "dis.)>", DISDOTRPARENGT 
	.word XT_DOLITERAL # [char]
	.word 41 # )
	.word XT_EMIT
	.word XT_EXIT
# ----------------------------------------------------------------------
COLON "dis.reg>", DISDOTREGGT 
	.word XT_DISDOTREGNAME
	.word XT_FETCH
	.word XT_SWAP
	.word XT_DOLITERAL
	.word 31
	.word XT_AND
	.word XT_CELLS
	.word XT_PLUS
	.word XT_DUP
	.word XT_CFETCH
	.word XT_SWAP
	.word XT_1PLUS
	.word XT_SWAP
	.word XT_TYPE
	.word XT_EXIT
# ----------------------------------------------------------------------
COLON "dis.asm", DISDOTASM 
	.word XT_TO_R
	.word XT_R_FETCH
	.word XT_FETCH
	.word XT_DISDOTOPDOTMASK
	.word XT_AND
	.word XT_DISDOTOP
	.word XT_STORE
	.word XT_R_FETCH
	.word XT_FETCH
	.word XT_DISDOTRDDOTMASK
	.word XT_AND
	.word XT_DOLITERAL
	.word 7
	.word XT_RSHIFT
	.word XT_DISDOTRD
	.word XT_STORE
	.word XT_R_FETCH
	.word XT_FETCH
	.word XT_DISDOTFN3DOTMASK
	.word XT_AND
	.word XT_DOLITERAL
	.word 12
	.word XT_RSHIFT
	.word XT_DISDOTFN3
	.word XT_STORE
	.word XT_R_FETCH
	.word XT_FETCH
	.word XT_DISDOTRS1DOTMASK
	.word XT_AND
	.word XT_DOLITERAL
	.word 15
	.word XT_RSHIFT
	.word XT_DISDOTRS1
	.word XT_STORE
	.word XT_R_FETCH
	.word XT_FETCH
	.word XT_DISDOTIMMUNDERIDOTMASK
	.word XT_AND
	.word XT_DOLITERAL
	.word 20
	.word XT_ASHIFT
	.word XT_DISDOTIMMUNDERI
	.word XT_STORE
	.word XT_R_FETCH
	.word XT_FETCH
	.word XT_DOLITERAL
	.word 0xfe000000
	.word XT_AND
	.word XT_DOLITERAL
	.word 25
	.word XT_RSHIFT
	.word XT_DISDOTFN7
	.word XT_STORE
	.word XT_R_FETCH
	.word XT_FETCH
	.word XT_DOLITERAL
	.word 0xfe000000
	.word XT_AND
	.word XT_DOLITERAL
	.word 20
	.word XT_ASHIFT
	.word XT_R_FETCH
	.word XT_FETCH
	.word XT_DOLITERAL
	.word 0xf80
	.word XT_AND
	.word XT_DOLITERAL
	.word 7
	.word XT_RSHIFT
	.word XT_OR
	.word XT_DISDOTIMMUNDERS
	.word XT_STORE
	.word XT_R_FETCH
	.word XT_FETCH
	.word XT_DOLITERAL
	.word 0b1111100000000000000000000
	.word XT_AND
	.word XT_DOLITERAL
	.word 20
	.word XT_RSHIFT
	.word XT_DISDOTRS2
	.word XT_STORE
	.word XT_R_FETCH
	.word XT_FETCH
	.word XT_DOLITERAL
	.word 0x80000000
	.word XT_AND
	.word XT_DOLITERAL
	.word 19
	.word XT_ASHIFT
	.word XT_R_FETCH
	.word XT_FETCH
	.word XT_DOLITERAL
	.word 0x7e000000
	.word XT_AND
	.word XT_DOLITERAL
	.word 20
	.word XT_RSHIFT
	.word XT_OR
	.word XT_R_FETCH
	.word XT_FETCH
	.word XT_DOLITERAL
	.word 0b10000000
	.word XT_AND
	.word XT_FOUR
	.word XT_LSHIFT
	.word XT_OR
	.word XT_R_FETCH
	.word XT_FETCH
	.word XT_DOLITERAL
	.word 0b111100000000
	.word XT_AND
	.word XT_DOLITERAL
	.word 7
	.word XT_RSHIFT
	.word XT_OR
	.word XT_DISDOTIMMUNDERB
	.word XT_STORE
	.word XT_R_FETCH
	.word XT_FETCH
	.word XT_DOLITERAL
	.word 12
	.word XT_ASHIFT
	.word XT_2STAR
	.word XT_DOLITERAL
	.word 0xfff00000
	.word XT_AND
	.word XT_R_FETCH
	.word XT_FETCH
	.word XT_DOLITERAL
	.word 0x7fe00000
	.word XT_AND
	.word XT_DOLITERAL
	.word 20
	.word XT_RSHIFT
	.word XT_OR
	.word XT_R_FETCH
	.word XT_FETCH
	.word XT_DOLITERAL
	.word 0x100000
	.word XT_AND
	.word XT_DOLITERAL
	.word 9
	.word XT_RSHIFT
	.word XT_OR
	.word XT_R_FETCH
	.word XT_FETCH
	.word XT_DOLITERAL
	.word 0xff000
	.word XT_AND
	.word XT_OR
	.word XT_DISDOTIMMUNDERJ
	.word XT_STORE
	.word XT_R_FETCH
	.word XT_FETCH
	.word XT_DOLITERAL
	.word 0b11111111111111111111000000000000
	.word XT_AND
	.word XT_DISDOTIMMUNDERU
	.word XT_STORE
	.word XT_DISDOTOP
	.word XT_FETCH
	.word XT_DOLITERAL
	.word 0x3
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,DISDOTASM_0001 # if
	.word XT_DISDOTFN3
	.word XT_FETCH
	.word XT_ZERO
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,DISDOTASM_0002 # if
	STRING "lb    "
	.word XT_TYPE
DISDOTASM_0002: # then
	.word XT_DISDOTFN3
	.word XT_FETCH
	.word XT_ONE
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,DISDOTASM_0003 # if
	STRING "lh    "
	.word XT_TYPE
DISDOTASM_0003: # then
	.word XT_DISDOTFN3
	.word XT_FETCH
	.word XT_TWO
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,DISDOTASM_0004 # if
	STRING "lw    "
	.word XT_TYPE
DISDOTASM_0004: # then
	.word XT_DISDOTFN3
	.word XT_FETCH
	.word XT_FOUR
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,DISDOTASM_0005 # if
	STRING "lbu   "
	.word XT_TYPE
DISDOTASM_0005: # then
	.word XT_DISDOTFN3
	.word XT_FETCH
	.word XT_DOLITERAL
	.word 5
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,DISDOTASM_0006 # if
	STRING "lhu   "
	.word XT_TYPE
DISDOTASM_0006: # then
	.word XT_DISDOTRD
	.word XT_FETCH
	.word XT_DISDOTREGGT
	.word XT_DISDOTCOMMAGT
	.word XT_DISDOTIMMUNDERI
	.word XT_FETCH
	.word XT_XDOT
	.word XT_DISDOTLPARENGT
	.word XT_DISDOTRS1
	.word XT_FETCH
	.word XT_DISDOTREGGT
	.word XT_DISDOTRPARENGT
	.word XT_RDROP
	.word XT_FINISH
DISDOTASM_0001: # then
	.word XT_DISDOTOP
	.word XT_FETCH
	.word XT_DOLITERAL
	.word 0x33
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,DISDOTASM_0007 # if
	.word XT_DISDOTFN7
	.word XT_FETCH
	.word XT_DOLITERAL
	.word 3
	.word XT_LSHIFT
	.word XT_DISDOTFN3
	.word XT_FETCH
	.word XT_OR
	.word XT_DUP
	.word XT_DOLITERAL
	.word 0b1000
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,DISDOTASM_0008 # if
	STRING "mul   "
	.word XT_TYPE
DISDOTASM_0008: # then
	.word XT_DUP
	.word XT_DOLITERAL
	.word 0b1001
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,DISDOTASM_0009 # if
	STRING "mulh  "
	.word XT_TYPE
DISDOTASM_0009: # then
	.word XT_DUP
	.word XT_DOLITERAL
	.word 0b1010
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,DISDOTASM_000A # if
	STRING "mulhsu "
	.word XT_TYPE
DISDOTASM_000A: # then
	.word XT_DUP
	.word XT_DOLITERAL
	.word 0b1011
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,DISDOTASM_000B # if
	STRING "mulhu "
	.word XT_TYPE
DISDOTASM_000B: # then
	.word XT_DUP
	.word XT_DOLITERAL
	.word 0b1100
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,DISDOTASM_000C # if
	STRING "div   "
	.word XT_TYPE
DISDOTASM_000C: # then
	.word XT_DUP
	.word XT_DOLITERAL
	.word 0b1101
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,DISDOTASM_000D # if
	STRING "divu  "
	.word XT_TYPE
DISDOTASM_000D: # then
	.word XT_DUP
	.word XT_DOLITERAL
	.word 0b1110
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,DISDOTASM_000E # if
	STRING "rem   "
	.word XT_TYPE
DISDOTASM_000E: # then
	.word XT_DUP
	.word XT_DOLITERAL
	.word 0b1111
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,DISDOTASM_000F # if
	STRING "remu  "
	.word XT_TYPE
DISDOTASM_000F: # then
	.word XT_DUP
	.word XT_DOLITERAL
	.word 0b0
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,DISDOTASM_0010 # if
	STRING "add   "
	.word XT_TYPE
DISDOTASM_0010: # then
	.word XT_DUP
	.word XT_DOLITERAL
	.word 0b100000000
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,DISDOTASM_0011 # if
	STRING "sub   "
	.word XT_TYPE
DISDOTASM_0011: # then
	.word XT_DUP
	.word XT_DOLITERAL
	.word 0b1
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,DISDOTASM_0012 # if
	STRING "sll   "
	.word XT_TYPE
DISDOTASM_0012: # then
	.word XT_DUP
	.word XT_DOLITERAL
	.word 0b10
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,DISDOTASM_0013 # if
	STRING "slt   "
	.word XT_TYPE
DISDOTASM_0013: # then
	.word XT_DUP
	.word XT_DOLITERAL
	.word 0b11
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,DISDOTASM_0014 # if
	STRING "sltu  "
	.word XT_TYPE
DISDOTASM_0014: # then
	.word XT_DUP
	.word XT_DOLITERAL
	.word 0b100
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,DISDOTASM_0015 # if
	STRING "xor   "
	.word XT_TYPE
DISDOTASM_0015: # then
	.word XT_DUP
	.word XT_DOLITERAL
	.word 0b101
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,DISDOTASM_0016 # if
	STRING "srl   "
	.word XT_TYPE
DISDOTASM_0016: # then
	.word XT_DUP
	.word XT_DOLITERAL
	.word 0b100000101
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,DISDOTASM_0017 # if
	STRING "sra   "
	.word XT_TYPE
DISDOTASM_0017: # then
	.word XT_DUP
	.word XT_DOLITERAL
	.word 0b110
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,DISDOTASM_0018 # if
	STRING "or    "
	.word XT_TYPE
DISDOTASM_0018: # then
	.word XT_DOLITERAL
	.word 0b111
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,DISDOTASM_0019 # if
	STRING "and   "
	.word XT_TYPE
DISDOTASM_0019: # then
	.word XT_DISDOTRD
	.word XT_FETCH
	.word XT_DISDOTREGGT
	.word XT_DISDOTCOMMAGT
	.word XT_DISDOTRS1
	.word XT_FETCH
	.word XT_DISDOTREGGT
	.word XT_DISDOTCOMMAGT
	.word XT_DISDOTRS2
	.word XT_FETCH
	.word XT_DISDOTREGGT
	.word XT_RDROP
	.word XT_FINISH
DISDOTASM_0007: # then
	.word XT_DISDOTOP
	.word XT_FETCH
	.word XT_DOLITERAL
	.word 0x13
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,DISDOTASM_001A # if
	.word XT_DISDOTFN3
	.word XT_FETCH
	.word XT_ZERO
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,DISDOTASM_001B # if
	STRING "addi  "
	.word XT_TYPE
DISDOTASM_001B: # then
	.word XT_DISDOTFN3
	.word XT_FETCH
	.word XT_FOUR
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,DISDOTASM_001C # if
	STRING "xori  "
	.word XT_TYPE
DISDOTASM_001C: # then
	.word XT_DISDOTFN3
	.word XT_FETCH
	.word XT_DOLITERAL
	.word 6
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,DISDOTASM_001D # if
	STRING "ori   "
	.word XT_TYPE
DISDOTASM_001D: # then
	.word XT_DISDOTFN3
	.word XT_FETCH
	.word XT_DOLITERAL
	.word 7
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,DISDOTASM_001E # if
	STRING "andi  "
	.word XT_TYPE
DISDOTASM_001E: # then
	.word XT_DISDOTFN3
	.word XT_FETCH
	.word XT_ONE
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,DISDOTASM_001F # if
	STRING "slli  "
	.word XT_TYPE
DISDOTASM_001F: # then
	.word XT_DISDOTFN3
	.word XT_FETCH
	.word XT_DOLITERAL
	.word 5
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,DISDOTASM_0020 # if
	STRING "srxi  "
	.word XT_TYPE
DISDOTASM_0020: # then
	.word XT_DISDOTFN3
	.word XT_FETCH
	.word XT_TWO
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,DISDOTASM_0021 # if
	STRING "slti  "
	.word XT_TYPE
DISDOTASM_0021: # then
	.word XT_DISDOTFN3
	.word XT_FETCH
	.word XT_DOLITERAL
	.word 3
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,DISDOTASM_0022 # if
	STRING "sltiu "
	.word XT_TYPE
DISDOTASM_0022: # then
	.word XT_DISDOTRD
	.word XT_FETCH
	.word XT_DISDOTREGGT
	.word XT_DISDOTCOMMAGT
	.word XT_DISDOTRS1
	.word XT_FETCH
	.word XT_DISDOTREGGT
	.word XT_DISDOTCOMMAGT
	.word XT_DISDOTIMMUNDERI
	.word XT_FETCH
	.word XT_XDOT
	.word XT_RDROP
	.word XT_FINISH
DISDOTASM_001A: # then
	.word XT_DISDOTOP
	.word XT_FETCH
	.word XT_DOLITERAL
	.word 0x23
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,DISDOTASM_0023 # if
	.word XT_DISDOTFN3
	.word XT_FETCH
	.word XT_ZERO
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,DISDOTASM_0024 # if
	STRING "sb    "
	.word XT_TYPE
DISDOTASM_0024: # then
	.word XT_DISDOTFN3
	.word XT_FETCH
	.word XT_ONE
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,DISDOTASM_0025 # if
	STRING "sh    "
	.word XT_TYPE
DISDOTASM_0025: # then
	.word XT_DISDOTFN3
	.word XT_FETCH
	.word XT_TWO
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,DISDOTASM_0026 # if
	STRING "sw    "
	.word XT_TYPE
DISDOTASM_0026: # then
	.word XT_DISDOTRS2
	.word XT_FETCH
	.word XT_DISDOTREGGT
	.word XT_DISDOTCOMMAGT
	.word XT_DISDOTIMMUNDERS
	.word XT_FETCH
	.word XT_XDOT
	.word XT_DISDOTLPARENGT
	.word XT_DISDOTRS1
	.word XT_FETCH
	.word XT_DISDOTREGGT
	.word XT_DISDOTRPARENGT
	.word XT_RDROP
	.word XT_FINISH
DISDOTASM_0023: # then
	.word XT_DISDOTOP
	.word XT_FETCH
	.word XT_DOLITERAL
	.word 0x63
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,DISDOTASM_0027 # if
	.word XT_DISDOTFN3
	.word XT_FETCH
	.word XT_ZERO
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,DISDOTASM_0028 # if
	STRING "beq   "
	.word XT_TYPE
DISDOTASM_0028: # then
	.word XT_DISDOTFN3
	.word XT_FETCH
	.word XT_ONE
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,DISDOTASM_0029 # if
	STRING "bne   "
	.word XT_TYPE
DISDOTASM_0029: # then
	.word XT_DISDOTFN3
	.word XT_FETCH
	.word XT_FOUR
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,DISDOTASM_002A # if
	STRING "blt   "
	.word XT_TYPE
DISDOTASM_002A: # then
	.word XT_DISDOTFN3
	.word XT_FETCH
	.word XT_DOLITERAL
	.word 5
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,DISDOTASM_002B # if
	STRING "bge   "
	.word XT_TYPE
DISDOTASM_002B: # then
	.word XT_DISDOTFN3
	.word XT_FETCH
	.word XT_DOLITERAL
	.word 6
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,DISDOTASM_002C # if
	STRING "bltu  "
	.word XT_TYPE
DISDOTASM_002C: # then
	.word XT_DISDOTFN3
	.word XT_FETCH
	.word XT_DOLITERAL
	.word 7
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,DISDOTASM_002D # if
	STRING "bgeu  "
	.word XT_TYPE
DISDOTASM_002D: # then
	.word XT_DISDOTRS1
	.word XT_FETCH
	.word XT_DISDOTREGGT
	.word XT_DISDOTCOMMAGT
	.word XT_DISDOTRS2
	.word XT_FETCH
	.word XT_DISDOTREGGT
	.word XT_DISDOTCOMMAGT
	.word XT_DISDOTIMMUNDERB
	.word XT_FETCH
	.word XT_XDOT
DISDOTASM_0027: # then
	.word XT_DISDOTOP
	.word XT_FETCH
	.word XT_DOLITERAL
	.word 0x6f
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,DISDOTASM_002E # if
	STRING "jal   "
	.word XT_TYPE
	.word XT_DISDOTRD
	.word XT_FETCH
	.word XT_DISDOTREGGT
	.word XT_DISDOTCOMMAGT
	.word XT_DISDOTIMMUNDERJ
	.word XT_FETCH
	.word XT_XDOT
	.word XT_SPACE
	.word XT_DISDOTLPARENGT
	.word XT_DISDOTIMMUNDERJ
	.word XT_FETCH
	.word XT_R_FETCH
	.word XT_PLUS
	.word XT_DUP
	.word XT_8XDOT
	.word XT_DISDOTRPARENGT
	.word XT_CON_DONEXT
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,DISDOTASM_002F # if
	STRING " NEXT"
	.word XT_TYPE
DISDOTASM_002F: # then
DISDOTASM_002E: # then
	.word XT_DISDOTOP
	.word XT_FETCH
	.word XT_DOLITERAL
	.word 0x67
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,DISDOTASM_0030 # if
	STRING "jalr  "
	.word XT_TYPE
	.word XT_DISDOTRD
	.word XT_FETCH
	.word XT_DISDOTREGGT
	.word XT_DISDOTCOMMAGT
	.word XT_DISDOTRS1
	.word XT_FETCH
	.word XT_DISDOTREGGT
	.word XT_DISDOTCOMMAGT
	.word XT_DISDOTIMMUNDERI
	.word XT_FETCH
	.word XT_XDOT
DISDOTASM_0030: # then
	.word XT_DISDOTOP
	.word XT_FETCH
	.word XT_DOLITERAL
	.word 0x37
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,DISDOTASM_0031 # if
	STRING "lui   "
	.word XT_TYPE
	.word XT_DISDOTRD
	.word XT_FETCH
	.word XT_DISDOTREGGT
	.word XT_DISDOTCOMMAGT
	.word XT_DISDOTIMMUNDERU
	.word XT_FETCH
	.word XT_8XDOT
DISDOTASM_0031: # then
	.word XT_DISDOTOP
	.word XT_FETCH
	.word XT_DOLITERAL
	.word 0x17
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,DISDOTASM_0032 # if
	STRING "auipc "
	.word XT_TYPE
	.word XT_DISDOTRD
	.word XT_FETCH
	.word XT_DISDOTREGGT
	.word XT_DISDOTCOMMAGT
	.word XT_DISDOTIMMUNDERU
	.word XT_FETCH
	.word XT_DOLITERAL
	.word 12
	.word XT_ASHIFT
	.word XT_DOT
DISDOTASM_0032: # then
	.word XT_RDROP
	.word XT_EXIT
# ----------------------------------------------------------------------
COLON "dis.dump", DISDOTDUMP 
	.word XT_1PLUS
	.word XT_OVER
	.word XT_SWAP
	.word XT_CELLS
	.word XT_PLUS
	.word XT_SWAP
	.word XT_QDOCHECK, XT_DOCONDBRANCH,DISDOTDUMP_0001 # ?do
	.word XT_DODO
DISDOTDUMP_0002: # do
	.word XT_I
	.word XT_HEXDOT
	.word XT_I
	.word XT_DISDOTASM
	.word XT_CR
	.word XT_CELL
	.word XT_DOPLUSLOOP,DISDOTDUMP_0002 # +loop
DISDOTDUMP_0001: # (for ?do IF required) 
	.word XT_EXIT
