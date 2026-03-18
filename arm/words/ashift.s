CODEWORD "ashift", ASHIFT /* ( n1 u -- n2  ) n2 = n1 >> u (arithmetic shift right, sign filled) */
  popnos r0
  asr r0, r0, tos
  movs tos, r0
  NEXT
END ASHIFT
