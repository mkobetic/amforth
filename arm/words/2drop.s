CODEWORD "2drop", 2DROP /* ( x1 x2 -- ) drop top 2 cells from the stack */
  add psp, #4
  loadtos
  NEXT
END 2DROP
