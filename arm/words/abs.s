CODEWORD "abs", ABS /* ( n1 -- n2 ) n2 = abs(n1) */
  cmp tos, #0
  it lt
  neglt tos, tos
  NEXT
END ABS
