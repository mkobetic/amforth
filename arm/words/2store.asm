CODEWORD  "2!", 2STORE /* ( d addr -- ) store two cells at addr */
  ands r0, tos, #0x3     /* cell aligned?         */
  beq  1f                /* branch if OK          */
  throw EADRINV          /* not aligned so throw  */
1:                       /* normal operation      */
  ldmia psp!, {r1, r2}
  str r1, [tos]
  str r2, [tos, #4]
  ldm psp!, {tos}
  NEXT
END 2STORE
