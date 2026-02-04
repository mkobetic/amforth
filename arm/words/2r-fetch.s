CODEWORD "2r@", 2R_FETCH /* (R: x1 x2 -- x1 x2 )( -- x1 x2) copy 2 cells from return stack to stack */
  savetos
  ldr tos, [sp, #4]
  savetos
  ldr tos, [sp]
  NEXT
END 2R_FETCH
