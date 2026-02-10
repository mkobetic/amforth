# SPDX-License-Identifier: GPL-3.0-only

CODEWORD "naligned" , NALIGNED /* ( n a1 -- a2 ) a2 is n aligned a1 )  */
naligned:
    ldr     r1, [psp]       @ r1 = n (byte count from NOS)
    add     psp, psp, #4    @ pop stack (remove n)

    sub     r0, r1, #1      @ r0 = n - 1 (alignment mask)
    add     tos, tos, r0    @ tos = a + (n - 1)
    mvn     r0, r0          @ r0 = ~(n - 1)
    and     tos, tos, r0    @ tos = (a + mask) & ~mask

    @ tos now contains aligned address (new TOS)
    NEXT                    @ return to Forth interpreter
END NALIGNED
