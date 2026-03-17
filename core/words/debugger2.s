
CONSTANT "docolon", DOCOLON, DOCOLON /* value of XT of colon words */
END DOCOLON

USER "debug.next", DEBUG_NEXT, USER_DEBUG_NEXT /* next debug action, 0 if none */
END DEBUG_NEXT

USER "debug.break", DEBUG_BREAK, USER_DEBUG_BREAK /* XT of debugger, invoked when BREAK is reached */
END DEBUG_BREAK

IMMED "\073d", SEMICOLOND /* MUST be used to end debug hook word definition */
        .word XT_COMPILE
        .word XT_EXITD
        .word XT_LBRACKET
        .word XT_REVEAL
        .word XT_FLASHDOTFLUSH
        .word XT_EXIT
END SEMICOLOND
