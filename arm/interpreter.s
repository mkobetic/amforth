.global _INTERPRETER
.type _INTERPRETER, STT_FUNC
_INTERPRETER:
DOCOLON: 
        push {FORTHIP}
        mov FORTHIP, FORTHW
DO_NEXT:
        ldr FORTHW, [FORTHIP], #4
DO_EXECUTE:
        ldr r0, [FORTHW], #4
        mov pc, r0
.size _INTERPRETER, . - _INTERPRETER
