# SPDX-License-Identifier: GPL-3.0-only

COLON "immediate", IMMEDIATE /* ( -- ) set immediate flag for the most recent word definition (RAM words only) */
    .word XT_GET_CURRENT,XT_EXECUTE
    .word XT_DUP, XT_DOLITERAL,Flag_immediate
    .word XT_ROT, XT_FETCH, XT_OR, XT_SWAP, XT_STORE
    .word XT_EXIT
END IMMEDIATE
