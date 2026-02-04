
@ -----------------------------------------------------------------------------
  CODEWORD "rot", ROT /* (n1 n2 n3 -- n2 n3 n1) rotate stack so that 3rd cell is at TOS */
@ -----------------------------------------------------------------------------
  ldm psp!, {r0, r1}
  subs psp, #8
  str r0, [psp, #4]
  str tos, [psp]
  movs tos, r1
  NEXT
END ROT
