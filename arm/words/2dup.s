CODEWORD "2dup", 2DUP /* ( n1 n2 -- n1 n2 n1 n2) duplicate top 2 cells on the stack */
  ldr r0, [psp]
  savetos
  sub psp, #4
  str r0, [psp]
  NEXT
END 2DUP
