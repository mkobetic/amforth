@ -----------------------------------------------------------------------------
  COLON "mod", MOD @ ( n1 n2 -- rem )
@ -----------------------------------------------------------------------------
  .word XT_SLASHMOD, XT_DROP
  .word XT_EXIT

@ -----------------------------------------------------------------------------
  COLON "/", SLASH @ ( n1 n2 -- n1/n2 )
@ -----------------------------------------------------------------------------
  .word XT_SLASHMOD, XT_NIP
  .word XT_EXIT

@ -----------------------------------------------------------------------------
  CODEWORD "/mod",SLASHMOD @ ( n1 n2 -- rem quot )
@ -----------------------------------------------------------------------------
  cbnz tos, 1f  @ throw if divisor is zero
  throw EDIVZ
1:  
  ldm psp!, {r0}     @ Get u1 into a register
  movs r1, tos       @ Back up the divisor in X.
  sdiv tos, r0, tos  @ Divide: quotient in TOS.
  @ TODO: should be able to use mls to do muls/subs in one instruction
  @  mls  r3, r2, r1, r0  @ r3 = r0 - (r2 * r1)
  muls r1, tos, r1   @ Un-divide to compute remainder.
  subs r0, r1        @ Compute remainder.
  subs psp, #4
  str r0, [psp]
  NEXT
@ -----------------------------------------------------------------------------
  CODEWORD "u/mod", USLASHMOD @ ( u1 u2 -- rem quot )
  ldm psp!, {r0}      @ Get u1 into a register
  movs r1, tos        @ Back up the divisor in X.
  udiv tos, r0, tos   @ Divide: quotient in TOS.
  muls r1, tos, r1    @ Un-divide to compute remainder.
  subs r0, r1         @ Compute remainder.
  subs psp, #4
  str r0, [psp]
  NEXT
