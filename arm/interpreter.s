.global _INTERPRETER
.type _INTERPRETER, STT_FUNC
_INTERPRETER:
.thumb_func /* need to set the thumb bit on the DOCOLON symbol */
DOCOLON: 
        push {FORTHIP}
        mov FORTHIP, FORTHW
.thumb_func
DO_NEXT:
        /* if debug hook is set interrupt the DO_NEXT cycle */
        cbz DEBUG, DO_NEXT1
        ldr FORTHW, [up, USER_DEBUG_BREAK] /* load debugger into FORTHW */
        mov DEBUG, #0 /* clear DEBUG */
        b DO_EXECUTE
DO_NEXT1:
        ldr FORTHW, [FORTHIP], #4
.thumb_func
DO_EXECUTE:
        ldr r0, [FORTHW], #4
        bx r0
.size _INTERPRETER, . - _INTERPRETER


USER "debug.next", DEBUG_NEXT, USER_DEBUG_NEXT /* next debug action, 0 if none */
END DEBUG_NEXT

CODEWORD "(exitd)", EXITD /* ( -- ) exit from a debugger word */
        /* restore DEBUG hook */
        ldr DEBUG, [up, USER_DEBUG_NEXT]
        pop {FORTHIP} /* restore FORTHIP */
        b DO_NEXT1 /* finish the interrupted DO_NEXT */
        .ltorg
END EXITD

IMMED "\073d", SEMICOLOND /* MUST be used to end debug hook word definition */
        .word XT_COMPILE
        .word XT_EXITD
        .word XT_LBRACKET
        .word XT_REVEAL
        .word XT_FLASHDOTFLUSH
        .word XT_EXIT
END SEMICOLOND

USER "debug.break", DEBUG_BREAK, USER_DEBUG_BREAK /* XT of debugger, invoked when BREAK is reached */
END DEBUG_BREAK

.equ DEBUG_STEP, 1

CODEWORD "break", BREAK /* ( -- ) activate the debugger (if enabled) */
        /* check if we are already debugging */
        cbnz DEBUG, 1f
        /* check if debugger is enabled */
        ldr DEBUG, [up, USER_DEBUG_BREAK]
        cbz DEBUG, 1f
        /* set debug.next to debug_step */
        mov DEBUG, #DEBUG_STEP
        str DEBUG, [up, USER_DEBUG_NEXT]
1:      NEXT
END BREAK

CODEWORD "debug_buf", DEBUG_BUF /* ( -- addr ) debugger input buffer address */
  savetos
  ldr tos, =RAM_lower_debug_buf
  NEXT
END DEBUG_BUF
