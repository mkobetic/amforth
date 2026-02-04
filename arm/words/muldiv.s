@ -----------------------------------------------------------------------------
  COLON "mod", MOD /* ( n1 n2 -- n3 ) n3 is remainder of n1 / n2 */
@ -----------------------------------------------------------------------------
  .word XT_SLASHMOD, XT_DROP
  .word XT_EXIT
END MOD

@ -----------------------------------------------------------------------------
  COLON "/", SLASH /* ( n1 n2 -- n3 ) n3 is quotient of n1 / n2 */
@ -----------------------------------------------------------------------------
  .word XT_SLASHMOD, XT_NIP
  .word XT_EXIT
END SLASH

@ -----------------------------------------------------------------------------
  CODEWORD "/mod", SLASHMOD /* ( n1 n2 -- n3 n4 ) n3 is remainder and n4 the quotient of n1 / n2 */
@ -----------------------------------------------------------------------------
  cbnz tos, slashmod  @ throw if divisor is zero
  throw EDIVZ
slashmod:  
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
END SLASHMOD

@ -----------------------------------------------------------------------------
  CODEWORD "u/mod", USLASHMOD /* ( u1 u2 -- u3 u4 ) u3 is remainder and u4 the quotient of u1 / u2 */
@ -----------------------------------------------------------------------------
  cbnz tos, uslashmod  @ throw if divisor is zero
  throw EDIVZ
uslashmod:  
  ldm psp!, {r0}      @ Get u1 into a register
  movs r1, tos        @ Back up the divisor in X.
  udiv tos, r0, tos   @ Divide: quotient in TOS.
  muls r1, tos, r1    @ Un-divide to compute remainder.
  subs r0, r1         @ Compute remainder.
  subs psp, #4
  str r0, [psp]
  NEXT
END USLASHMOD
