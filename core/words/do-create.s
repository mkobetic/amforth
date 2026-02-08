# SPDX-License-Identifier: GPL-3.0-only

COLON "(create)", DOCREATE /* ( "<spaces>name" -- ) parse name, write header, set newest */
    .word XT_PARSENAME,XT_WLSCOPE
    .word XT_DOCREATE_IN
    .word XT_EXIT
END DOCREATE

NONAME DOCREATE_IN
    .word XT_DUP,XT_NEWEST,XT_CELLPLUS,XT_STORE
    .word XT_HEADER,XT_NEWEST,XT_STORE         
    .word XT_EXIT
END DOCREATE_IN
