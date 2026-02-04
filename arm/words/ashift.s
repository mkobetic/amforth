CODEWORD "ashift", ASHIFT /* ( n1 n2 -- n3  ) n3 = n1 >> n2, arithmetic shift n1 right n2 bits (sign fill) */
  ldm psp!, {r0}
  asr r0, r0, tos
  movs tos, r0
  NEXT
END ASHIFT
