.global _INTERPRETER
.type _INTERPRETER, STT_FUNC
_INTERPRETER:
.thumb_func /* need to set the thumb bit on the DOCOLON symbol */
DOCOLON: 
        push {FORTHIP}
        mov FORTHIP, FORTHW
.thumb_func
DO_NEXT:
        ldr FORTHW, [FORTHIP], #4
.thumb_func
DO_EXECUTE:
        ldr r0, [FORTHW], #4
        bx r0
.size _INTERPRETER, . - _INTERPRETER
