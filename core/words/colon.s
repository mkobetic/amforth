# SPDX-License-Identifier: GPL-3.0-only


# MFD MFD 
# complicated
# for the transpiler I want to be able to create NONAME XT 
# from forth code that will still compile (to flash or ram)
# just as if it were : above
# eg
#
# :  xx 1+ ;
# :n xx 1+ ;
#
# will generate the same code when compiled, but when transpiled
# :n will not create a dictionary entry. The assembler (gas) will
# know what to do with it but the operator will not be able to find
# nor access it 

# COLON ":c", CLOAKED
#     .word XT_FLAGDOTCOLON
#     .word XT_FLAGDOTCLOAKED
#     .word XT_OR
#     .word XT_DOTO
#     .word XT_FLAGDOTHEADER
#     .word XT_DOCREATE
#     .word XT_COLONNONAME
#     .word XT_DROP
#     .word XT_EXIT

# VALUE "cloak?" , CLOAKQ , -1

.ifnb

COLON ":", COLON
    .word XT_FLAGDOTCOLON
    .word XT_DOTO
    .word XT_FLAGDOTHEADER
    .word XT_DOCREATE
    .word XT_COLONNONAME
    .word XT_DROP
    .word XT_EXIT


COLON ":~", CLOAKED_COLON 
    .word XT_FLAGDOTCOLON
    .word XT_FLAGDOTCLOAKED
    .word XT_OR
    .word XT_DOTO
    .word XT_FLAGDOTHEADER
    .word XT_DOCREATE
    .word XT_COLONNONAME
    .word XT_DROP
    .word XT_EXIT

.else

COLON ":", COLON
    .word XT_FLAGDOTCOLON
    .word XT_FLAGDOTPRIVATEQ
    .word XT_OR
    .word XT_DOTO
    .word XT_FLAGDOTHEADER
    .word XT_DOCREATE
    .word XT_COLONNONAME
    .word XT_DROP
    .word XT_EXIT


COLON ":~", CLOAKED_COLON 
    .word XT_FLAGDOTCOLON
    .word XT_FLAGDOTPRIVATE
    .word XT_OR
    .word XT_DOTO
    .word XT_FLAGDOTHEADER
    .word XT_DOCREATE
    .word XT_COLONNONAME
    .word XT_DROP
    .word XT_EXIT

.endif
