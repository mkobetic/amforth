CODEWORD "cell+", CELLPLUS /* ( n1 -- n2 ) n2 = n1 + cellsize */
  add tos, #cellsize
  NEXT
END CELLPLUS
