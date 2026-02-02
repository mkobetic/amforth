@------------------------------------------------------------------------------
  CODEWORD  "m*", MSTAR
  @ Multiply signed 32*32 = 64
  @ ( n n -- d )
@------------------------------------------------------------------------------
    ldr r0, [psp]
    smull r0, tos, tos, r0
    str r0, [psp]
    NEXT

@------------------------------------------------------------------------------
  CODEWORD  "ud/mod", UDSLASHMOD
         @ Unsigned divide 64/64 = 64 remainder 64
         @ ( ud1 ud2 -- ud ud)
         @ ( 1L 1H 2L tos: 2H -- Rem-L Rem-H Quot-L tos: Quot-H )
@------------------------------------------------------------------------------
@ use faster um/mod if divisor is 32-bits
@ TODO: This crashes hard in QEMU, why?
@   cbnz tos, 1f
@   loadtos
@   b umslashmod
@ 1:
@  throw if divisor is zero
  ldr  r0, [psp, #0]
  orrs r0, r0, tos
  bne 2f
  throw EDIVZ
2:
  bl ud_slash_mod
NEXT

ud_slash_mod:
   push {r4, r5}

   @ ( DividendL DividendH DivisorL DivisorH -- RemainderL RemainderH ResultL ResultH )
   @   8         4         0        tos      -- 8          4          0       tos
  dndlo .req r0 @ Dividend-Low / Quotient-Low
  dndhi .req r1 @ Dividend-High / Quotient-High
  remlo .req r2 @ Remainder-Low
  remhi .req r3 @ Remainder-High
  dsrlo .req r4 @ Divisor-Low
  dsrhi .req r5 @ Divisor-High
  @ tos used for iteration index

   movs remhi, #0 @ initialize remainder
   movs remlo, #0
   ldr  dndhi, [psp, #4] @ load dividend
   ldr  dndlo, [psp, #8]
   movs dsrhi, tos  @ load divisor
   ldr  dsrlo, [psp, #0]
   mov tos, #64 @ 64 individual long division steps.
3:
    @ Shift the long chain of four registers.
    lsls dndlo, #1
    adcs dndhi, dndhi
    adcs remlo, remlo
    adcs remhi, remhi

    @ Compare Divisor with top two registers
    cmp remhi, dsrhi @ Check high part first
    bhi 1f
    blo 2f

    cmp remlo, dsrlo @ High part is identical. Low part decides.
    blo 2f

    @ Subtract Divisor from two top registers
1:  subs remlo, dsrlo @ Subtract low part
    sbcs remhi, dsrhi @ Subtract high part with carry

    @ Insert a bit into Result which is inside LSB of the long register.
    adds dndlo, #1
2:
   subs tos, #1
   bne 3b

   @ Now place all values to their destination.
   movs tos, dndhi       @ Quotient-High
   str  dndlo, [psp, #0] @ Quotient-Low
   str  remhi, [psp, #4] @ Remainder-High
   str  remlo, [psp, #8] @ Remainder-Low

   pop {r4, r5}
   bx lr

   .unreq dndlo
   .unreq dndhi
   .unreq dsrlo
   .unreq remlo
   .unreq remhi

@------------------------------------------------------------------------------
  CODEWORD  "d/mod", DSLASHMOD
              @ Signed symmetric divide 64/64 = 64 remainder 64
              @ ( d1 d2 -- d d )
  @ throw if dividend is zero
  ldr  r0, [psp, #0]
  orrs r0, r0, tos
  bne 1f
  throw EDIVZ
1:
  bl d_slash_mod
NEXT

d_slash_mod:  @ ( 1L 1H 2L tos: 2H -- Rem-L Rem-H Quot-L tos: Quot-H )
@------------------------------------------------------------------------------
  @ Check Divisor
  push {lr}
  movs r0, tos, asr #31 @ Turn MSB into 0xffffffff or 0x00000000
  beq 2f
    @ ? / -
    bl dnegate
    bl dswap
    movs r0, tos, asr #31 @ Turn MSB into 0xffffffff or 0x00000000
    beq 1f
    @ - / -
    bl dnegate
    bl dswap
    bl ud_slash_mod

    bl dswap
    bl dnegate @ Negative remainder
    bl dswap
    pop {pc}

1:  @ + / -
    bl dswap
    bl ud_slash_mod
    bl dnegate  @ Negative result
    pop {pc}

2:  @ ? / +
    bl dswap
    movs r0, tos, asr #31 @ Turn MSB into 0xffffffff or 0x00000000
    beq 3f
    @ - / +
    bl dnegate
    bl dswap

    bl ud_slash_mod

    bl dnegate @ Negative result
    bl dswap
    bl dnegate @ Negative remainder
    bl dswap
    pop {pc}

3:  @ + / +
    bl dswap
    bl ud_slash_mod
    pop {pc}

@------------------------------------------------------------------------------
  CODEWORD  "d/", DSLASH
@------------------------------------------------------------------------------
  bl d_slash_mod
  ldm psp!, {r0, r1, r2}
  subs psp, #4
  str r0, [psp]
  NEXT


@------------------------------------------------------------------------------
@ --- Double comparisions ---
@------------------------------------------------------------------------------

@------------------------------------------------------------------------------
  CODEWORD  "d<", DLESS
  @ ( 2L 2H 1L 1H -- Flag )
  @   8y 4x 0w tos
@------------------------------------------------------------------------------
  ldm psp!, {r0, r1, r2}

  @ Check High:
  cmp tos, r1
  bgt 2f @ True
  bne 1f @ False - Not bigger, not equal --> Lower.
  @ Fall through if high part is equal

  @ Check Low:
  cmp r0, r2
  bgt 2f

@ False:
1:movs tos, #0
NEXT

@ True
2:movs tos, #0
  mvns tos, tos
NEXT

@------------------------------------------------------------------------------
  CODEWORD  "d>", DGREATER
  @ ( 2L 2H 1L 1H -- Flag )
  @   8y 4x 0w tos
@------------------------------------------------------------------------------
  ldm psp!, {r0, r1, r2}

  @ Check High:
  cmp r1, tos
  bgt 2f @ True
  bne 1f @ False - Not bigger, not equal --> Lower.
  @ Fall through if high part is equal

  @ Check Low:
  cmp r2, r0
  bgt 2f

@ False:
1:movs tos, #0
NEXT

@ True
2:movs tos, #0
  mvns tos, tos
NEXT

@------------------------------------------------------------------------------
  CODEWORD  "d0<", DZEROLESS @ ( 1L 1H -- Flag ) Is double number negative ?
@------------------------------------------------------------------------------
  adds psp, #4
  movs TOS, TOS, asr #31    @ Turn MSB into 0xffffffff or 0x00000000
NEXT

@------------------------------------------------------------------------------
  CODEWORD  "d0=", DZEROEQUAL @ ( 1L 1H -- Flag )
@------------------------------------------------------------------------------
  ldm psp!, {r0}
  cmp r0, #0
  beq 1f
    movs tos, #0
NEXT

1:subs tos, #1
  sbcs tos, tos
NEXT

@------------------------------------------------------------------------------
  CODEWORD  "d=", DEQUAL @ ( 1L 1H 2L 2H -- Flag )
@------------------------------------------------------------------------------
  ldm psp!, {r0, r1, r2}

  cmp r0, r2
  beq 1f
    movs tos, #0
NEXT

1:subs tos, r1       @ Z=equality; if equal, TOS=0
  subs tos, #1      @ Wenn es Null war, gibt es jetzt einen Überlauf
  sbcs tos, tos
NEXT

CODEWORD  "s>d", S2D
  savetos
  movs tos, tos, asr #31
NEXT
