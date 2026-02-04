CODEWORD "2r@", 2R_FETCH /* (R: d -- d )( -- d ) copy top 2 cells from return stack to stack */
  savetos
  ldr tos, [sp, #4]
  savetos
  ldr tos, [sp]
  NEXT
END 2R_FETCH
