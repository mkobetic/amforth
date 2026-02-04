CODEWORD  "invert", INVERT /* ( n1 -- n2 ) n2 = ~n1; bit-wise inversion */
  mvns tos,tos
  NEXT
END INVERT
