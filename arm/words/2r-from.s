CODEWORD "2r>", 2R_FROM /* (R: d -- )( -- d ) move top 2 cells from return stack to stack */
  savetos
  pop {tos}
  pop {r0}
  sub psp, #4
  str r0, [psp]
  NEXT
END 2R_FROM
