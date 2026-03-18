CODEWORD "2nip", 2NIP /* ( d2 d1 -- d1 ) remove 2nd cell pair from the stack */
  ldmia psp!, {r0, r1, r2}
  sub psp, #4
  str r0, [psp]
  NEXT
END 2NIP
