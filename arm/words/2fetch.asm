CODEWORD  "2@", 2FETCH /* ( addr - d ) fetch two cells at addr */
  ands r0, tos, #0x3     /* cell aligned?         */
  beq  1f                /* branch if OK          */
  throw EADRINV          /* not aligned so throw  */
1:                       /* normal operation      */
  subs psp, #4
  ldr r0, [tos, #4]
  str r0, [psp]
  ldr tos, [tos]
  NEXT
END 2FETCH
