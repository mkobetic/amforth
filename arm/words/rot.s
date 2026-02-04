
@ -----------------------------------------------------------------------------
  CODEWORD "rot", ROT /* (x1 x2 x3 -- x2 x3 x1) rotate top 3 cells on stack left, 3OS becomes TOS */
@ -----------------------------------------------------------------------------
  ldm psp!, {r0, r1}
  subs psp, #8
  str r0, [psp, #4]
  str tos, [psp]
  movs tos, r1
  NEXT
END ROT
