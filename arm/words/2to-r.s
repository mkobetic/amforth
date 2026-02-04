CODEWORD "2>r", 2TO_R /* (d -- )(R: -- d) move two cells from stack to return stack */
  ldm psp!, {r0}
  push {r0}
  push {tos}
  ldm psp!, {tos}
  NEXT
END 2TO_R
