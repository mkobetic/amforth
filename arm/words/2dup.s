CODEWORD "2dup", 2DUP /* ( d - d d )  duplicate top 2 cells on the stack */
  ldr r0, [psp]
  savetos
  sub psp, #4
  str r0, [psp]
  NEXT
END 2DUP
