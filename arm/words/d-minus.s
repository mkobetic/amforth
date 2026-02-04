@------------------------------------------------------------------------------
  CODEWORD "d-", DMINUS /* ( d1 d2 - d3 ) d3 = d1 - d2 */
@------------------------------------------------------------------------------
  ldm psp!, {r0, r1, r2}
  subs r2, r0     @  Low-part first
  sbcs r1, tos   @ High-part with carry
  movs tos, r1

  subs psp, #4
  str r2, [psp]
  NEXT
END DMINUS
