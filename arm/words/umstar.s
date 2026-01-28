/*
WORD: um*
STACK: ( u1 u2 -- ud )
SHORT: Multiply u1 by u2, giving the unsigned double-cell product ud.

All values and arithmetic are unsigned.
*/
CODEWORD  "um*", UMSTAR
    ldr r0, [psp]  @ To be calculated: Tos * r0
    umull r0, tos, tos, r0 @ umull lo, hi, x, y => hi:lo = x*y
    str r0, [psp]
NEXT
