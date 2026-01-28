/*
WORD: "um/mod"
STACK: ( ud u1 -- u2 u3 )
CATEG: MATH
SHORT: Divide ud by u1, giving the quotient u3 and the remainder u2.

All values and arithmetic are unsigned. An ambiguous condition exists if u1 is zero or if the quotient lies outside the range of a single-cell unsigned integer.
*/
CODEWORD "um/mod", UMSLASHMOD
    cbnz tos, 1f        @ throw if divisor is zero
    throw EDIVZ
1:
    bl umslashmod
    cbz tos, 2f      @ if quohi > 0, then quotient is too large
    throw ERANGE
2:
    loadtos @drop quohi
NEXT

@ call with bl umslashmod
@ Same algorithm as if performing the division by hand, just in binary.
@ Inputs:  hi:lo = 64-bit dividend, tos = 32-bit divisor
@ Outputs: hi:lo = 64-bit quotient, rem = 32-bit remainder
hi  .req r0 @ dividend-high
lo  .req r1 @ dividend-low
rem .req r2 @ reminder
dsr .req r3 @ divisor
umslashmod: @ ( dndlo dndhi dsr -- rem quolo quohi )
    popnos hi           @ load dividend-high
    cbnz hi, 3f          @ if hi == 0, use the quicker u/mod
    push {lr}
    bl uslashmod @ ( rem quolo )
    savetos
    mov tos, #0  @ ( rem quolo 0 )
    pop {pc}     @ return
3:
    popnos lo               @ load dividend-low
    @ TODO: could use CLZ to skip shifting through 0 bit prefix bit by bit and save some iterations
    mov     dsr, tos        @ load divisor
    mov     tos, #64        @ Loop counter for 64 bits
    mov     rem, #0         @ Initialize remainder to 0
1:  lsls    lo, lo, #1      @ Shift dividend/quotient low word
    adcs    hi, hi, hi      @ Shift dividend/quotient high word into carry (adc is how to lsl by 1 bit with carry)
    adcs    rem, rem, rem   @ Shift carry into remainder, also catch the bit shifting off at the top
    bcs     5f              @ If Carry is set, r3 is now effectively 33-bits, force the divisor subtraction 
    cmp     rem, dsr        @ Can we subtract the divisor?
    blo     2f              @ If remainder < divisor, skip
5:  sub     rem, rem, dsr   @ remainder -= divisor
    adds    lo, lo, #1      @ Set the lowest bit of quotient
2:  subs    tos, tos, #1    @ Decrement loop counter
    bne     1b

    pushnos rem
    pushnos lo
    mov tos, hi
    bx lr
.unreq rem
.unreq lo
.unreq hi

