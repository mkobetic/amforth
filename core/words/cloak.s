# SPDX-License-Identifier: GPL-3.0-only

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


VALUE "cloak?" , CLOAKQ , -1

COLON "+cloak" , PLUSCLOAK
    .word XT_TRUE
    .word XT_DOTO
    .word XT_CLOAKQ
    .word XT_EXIT

COLON "-cloak" , MINUSCLOAK
    .word XT_FALSE
    .word XT_DOTO
    .word XT_CLOAKQ
    .word XT_EXIT

