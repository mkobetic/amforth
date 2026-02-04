CODEWORD "2nip", 2NIP /* ( x4 x3 x2 x1 -- x2 x1 ) remove 3rd and 4th cell from the stack */
  ldm psp!, {r0, r1, r2}
  sub psp, #4
  str r0, [psp]
  NEXT
END 2NIP
