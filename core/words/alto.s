# SPDX-License-Identifier: GPL-3.0-only
# DIRTY
# original code base 'to', which is doing something clever and works
# for values defined in assembler but NOT from forth source, in any
# way I have tried. In .s files only XT_DOTO is ever executed, never XT_TO

# IMMED "to", TO
#     .word XT_TICK
#     .word XT_TO_BODY
#     .word XT_STATE
#     .word XT_FETCH
#     .word XT_DOCONDBRANCH, PFA_DOTO1
#       .word XT_COMPILE
#       .word XT_DOTO
#       .word XT_COMMA
#       .word XT_EXIT

# NONAME DOTO
#     .word XT_R_FROM
#     .word XT_DUP
#     .word XT_CELLPLUS
#     .word XT_TO_R
#     .word XT_FETCH
#     .word XT_DOTO1
#     .word XT_EXIT

# NONAME DOTO1
#     .word XT_CELLPLUS
#     .word XT_DUP, XT_FETCH, XT_SWAP
#     .word XT_CELLPLUS
#     .word XT_CELLPLUS
#     .word XT_CELLPLUS
#     .word XT_FETCH
#     .word XT_EXECUTE
#     .word XT_EXIT

# So XT_DOTO is needed, but this "to" is so is commented out 
# without issue (so far) 
#
# IMMED "to", TO
#     .word XT_TICK
#     .word XT_TO_BODY
#     .word XT_STATE
#     .word XT_FETCH
#     .word XT_DOCONDBRANCH, PFA_DOTO1
#       .word XT_COMPILE
#       .word XT_DOTO
#       .word XT_COMMA
#       .word XT_EXIT

NONAME DOTO
    .word XT_R_FROM
    .word XT_DUP
    .word XT_CELLPLUS
    .word XT_TO_R
    .word XT_FETCH
    .word XT_DOTO1
    .word XT_EXIT

NONAME DOTO1
    .word XT_CELLPLUS
    .word XT_DUP, XT_FETCH, XT_SWAP
    .word XT_CELLPLUS
    .word XT_CELLPLUS
    .word XT_CELLPLUS
    .word XT_FETCH
    .word XT_EXECUTE
    .word XT_EXIT

# which leaves us free to define a "to" which overwrite the value pointed to
# by the memory location pointed to by the PFA. 

#IMMED "to", PP
IMMED "pp", PP
    .word XT_TICK
    .word XT_TO_BODY
    .word XT_STATE
    .word XT_FETCH
    .word XT_DOCONDBRANCH, PFA_DOPP1
    .word XT_COMPILE
    .word XT_DOPP
    .word XT_COMMA
    .word XT_EXIT

COLON "(to)" , DOPP
    .word XT_R_FROM
    .word XT_DUP
    .word XT_CELLPLUS
    .word XT_TO_R
    .word XT_FETCH
    .word XT_DOPP1
    .word XT_EXIT

NONAME DOPP1
    .word XT_FETCH
    .word XT_STORE
    .word XT_EXIT
