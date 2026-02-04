CODEWORD "2over", 2OVER /* ( x1 x2 x3 x4 -- x1 x2 x3 x4 x1 x2 ) copy 3rd and 4th cell to top of the stack */
  ldr r0, [psp, #8]
  savetos
  sub psp, #4
  str r0, [psp]
  ldr tos, [psp, #12]  
  NEXT
END 2OVER
