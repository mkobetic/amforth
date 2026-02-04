@------------------------------------------------------------------------------
  CODEWORD "r@", R_FETCH /* (R: x -- x )( -- x ) copy top of return stack to data stack */
@------------------------------------------------------------------------------
  savetos
  ldr tos, [sp]
  NEXT
END R_FETCH
