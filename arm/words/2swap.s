CODEWORD "2swap", 2SWAP /* ( d1 d2 -- d2 d1 ) swap two cell pairs at the top of the stack */
  bl dswap
  NEXT

dswap:
  push {lr}
  ldm psp!, {r0, r1, r2}
  subs psp, #4
  str r0, [psp]
  savetos
  subs psp, #4
  str r2, [psp]
  movs tos, r1
  pop {pc}
END 2SWAP
