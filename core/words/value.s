# SPDX-License-Identifier: GPL-3.0-only
.ifnb

COLON "value", VAL /* ( x "name" -- ) create value "name" with initial value of x */
    .word XT_FLAGDOTVALUE
    .word XT_DOTO
    .word XT_FLAGDOTHEADER
    .word XT_DOCREATE
    .word XT_REVEAL
    .word XT_COMPILE
    .word PFA_DOVALUE
    .word XT_RAMHEREPLUSPLUS
    # added 
    .word XT_LBRACKET
    .word XT_TOFLUSH
    # end added 
    .word XT_EXIT
END VAL

COLON "value~", CLOAKED_VALUE /* ( x "name" -- ) create value "name" with initial value of x */
    .word XT_FLAGDOTVALUE
    .word XT_FLAGDOTCLOAKED
    .word XT_OR
    .word XT_DOTO
    .word XT_FLAGDOTHEADER
    .word XT_DOCREATE
    .word XT_REVEAL
    .word XT_COMPILE
    .word PFA_DOVALUE
    .word XT_RAMHEREPLUSPLUS
    # added 
    .word XT_LBRACKET
    .word XT_TOFLUSH
    # end added 
    .word XT_EXIT
END CLOAKED_VALUE

.else


COLON "value", VAL /* ( x "name" -- ) create value "name" with initial of x */
    .word XT_FLAGDOTVALUE
    .word XT_FLAGDOTPRIVATEQ
    .word XT_OR
    .word XT_DOTO
    .word XT_FLAGDOTHEADER
    .word XT_DOCREATE
    .word XT_REVEAL
    .word XT_COMPILE
    .word PFA_DOVALUE
    .word XT_RAMHEREPLUSPLUS
    # added 
    .word XT_LBRACKET
    .word XT_FLASHDOTFLUSH
    # end added 
    .word XT_EXIT
END VAL

COLON "value~", CLOAKED_VALUE /* ( x "name" -- ) create cloaked value "name" with initial of x */
    .word XT_FLAGDOTVALUE
    .word XT_FLAGDOTPRIVATE
    .word XT_OR
    .word XT_DOTO
    .word XT_FLAGDOTHEADER
    .word XT_DOCREATE
    .word XT_REVEAL
    .word XT_COMPILE
    .word PFA_DOVALUE
    .word XT_RAMHEREPLUSPLUS
    # added 
    .word XT_LBRACKET
    .word XT_FLASHDOTFLUSH
    # end added 
    .word XT_EXIT
END CLOAKED_VALUE

.endif 
