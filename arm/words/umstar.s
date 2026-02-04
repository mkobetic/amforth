CODEWORD  "um*", UMSTAR /* (u1 u2 -- ud ) ud = u1 * u2 */
    ldr r0, [psp]  @ To be calculated: Tos * r0
    umull r0, tos, tos, r0 @ umull lo, hi, x, y => hi:lo = x*y
    str r0, [psp]
    NEXT
END UMSTAR
