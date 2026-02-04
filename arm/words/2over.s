CODEWORD "2over", 2OVER /* ( d1 d2 -- d1 d2 d1 ) copy 2nd cell pair to the top of the stack */
  ldr r0, [psp, #8]
  savetos
  sub psp, #4
  str r0, [psp]
  ldr tos, [psp, #12]  
  NEXT
END 2OVER
