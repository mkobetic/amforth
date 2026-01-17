# SPDX-License-Identifier: GPL-3.0-only
.ifnb

COLON "value", VAL
# ( n "name" -- ) create value "name" with initial of n 
    .word XT_FLAGDOTVALUE
    .word XT_DOTO
    .word XT_FLAGDOTHEADER
    .word XT_RAMHERE
    .word XT_STORE
    .word XT_DOCREATE
    .word XT_REVEAL
    .word XT_COMPILE
    .word PFA_DOVALUE
    .word XT_RAMHEREPLUSPLUS
    .word XT_COMMA
    # added 
    .word XT_LBRACKET
    .word XT_TOFLUSH
    # end added 
    .word XT_EXIT

COLON "value~", CLOAKED_VALUE
# ( n "name" -- ) create value "name" with initial of n 
    .word XT_FLAGDOTVALUE
    .word XT_FLAGDOTCLOAKED
    .word XT_OR
    .word XT_DOTO
    .word XT_FLAGDOTHEADER
    .word XT_RAMHERE
    .word XT_STORE
    .word XT_DOCREATE
    .word XT_REVEAL
    .word XT_COMPILE
    .word PFA_DOVALUE
    .word XT_RAMHEREPLUSPLUS
    .word XT_COMMA
    # added 
    .word XT_LBRACKET
    .word XT_TOFLUSH
    # end added 
    .word XT_EXIT

.else


COLON "value", VAL
# ( n "name" -- ) create value "name" with initial of n 
    .word XT_FLAGDOTVALUE
    .word XT_FLAGDOTPRIVATEQ
    .word XT_OR
    .word XT_DOTO
    .word XT_FLAGDOTHEADER
    .word XT_RAMHERE
    .word XT_STORE
    .word XT_DOCREATE
    .word XT_REVEAL
    .word XT_COMPILE
    .word PFA_DOVALUE
    .word XT_RAMHEREPLUSPLUS
    .word XT_COMMA
    # added 
    .word XT_LBRACKET
#    .word XT_TOFLUSH
    # end added 
    .word XT_EXIT

COLON "value~", CLOAKED_VALUE
# ( n "name" -- ) create value "name" with initial of n 
    .word XT_FLAGDOTVALUE
    .word XT_FLAGDOTPRIVATE
    .word XT_OR
    .word XT_DOTO
    .word XT_FLAGDOTHEADER
    .word XT_RAMHERE
    .word XT_STORE
    .word XT_DOCREATE
    .word XT_REVEAL
    .word XT_COMPILE
    .word PFA_DOVALUE
    .word XT_RAMHEREPLUSPLUS
    .word XT_COMMA
    # added 
    .word XT_LBRACKET
#    .word XT_TOFLUSH
    # end added 
    .word XT_EXIT

.endif 
