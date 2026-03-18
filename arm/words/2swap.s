CODEWORD "2swap", 2SWAP /* ( d1 d2 -- d2 d1 ) swap top two cell pairs on the stack */
  bl dswap
  NEXT

dswap:
  ldm psp!, {r0, r1, r2}
  subs psp, #4
  str r0, [psp]
  savetos
  subs psp, #4
  str r2, [psp]
  movs tos, r1
  bx lr
END 2SWAP
