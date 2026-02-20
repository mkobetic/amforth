# SPDX-License-Identifier: GPL-3.0-only
.ifnb 

COLON "constant", CONSTANT /* ( -- x )(C: x "name" -- ) create constant "name" with value x */
    .word XT_FLAGDOTCON
    .word XT_DOTO
    .word XT_FLAGDOTHEADER
    .word XT_DOCREATE
    .word XT_REVEAL
    .word XT_COMPILE
    .word PFA_DOVARIABLE
    .word XT_COMMA
    .word XT_LBRACKET
    .word XT_TOFLUSH 
    .word XT_EXIT
END CONSTANT

COLON "constant~", CLOAKED_CONSTANT /* ( -- x )(C: x "name" -- ) create cloaked constant "name" with value x */
    .word XT_FLAGDOTCON
    .word XT_FLAGDOTCLOAKED
    .word XT_OR
    .word XT_DOTO
    .word XT_FLAGDOTHEADER
    .word XT_DOCREATE
    .word XT_REVEAL
    .word XT_COMPILE
    .word PFA_DOVARIABLE
    .word XT_COMMA
    .word XT_LBRACKET
    .word XT_TOFLUSH 
    .word XT_EXIT
END CLOAKED_CONSTANT

.else

COLON "constant", CONSTANT /* ( -- x )(C: x "name" -- ) create constant "name" with value x */
    .word XT_FLAGDOTCON
    .word XT_FLAGDOTPRIVATEQ
    .word XT_OR
    .word XT_DOTO
    .word XT_FLAGDOTHEADER
    .word XT_DOCREATE
    .word XT_REVEAL
    .word XT_COMPILE
    .word PFA_DOVARIABLE
    .word XT_COMMA
    .word XT_LBRACKET
    .word XT_FLASHDOTFLUSH
    .word XT_EXIT
END CONSTANT

# will need this for the transpiler so keep !

COLON "constant~", CLOAKED_CONSTANT /* ( -- x )(C: x "name" -- ) create cloaked constant "name" with value x */
    .word XT_FLAGDOTCON
    .word XT_FLAGDOTPRIVATE
    .word XT_OR
    .word XT_DOTO
    .word XT_FLAGDOTHEADER
    .word XT_DOCREATE
    .word XT_REVEAL
    .word XT_COMPILE
    .word PFA_DOVARIABLE
    .word XT_COMMA
    .word XT_LBRACKET
    .word XT_FLASHDOTFLUSH
    .word XT_EXIT
END CLOAKED_CONSTANT

.endif

