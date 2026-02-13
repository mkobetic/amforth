# SPDX-License-Identifier: GPL-3.0-only

COLON "get-current", GET_CURRENT /* ( -- wid ) get the current compilation word list */
    .word XT_CURRENT,XT_EXIT
END GET_CURRENT
