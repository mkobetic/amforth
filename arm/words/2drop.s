CODEWORD "2drop", 2DROP /* ( d -- ) drop top cell pair from the stack */
  add psp, #4
  loadtos
  NEXT
END 2DROP
