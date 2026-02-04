@ -----------------------------------------------------------------------------
  CODEWORD "swap", SWAP /* ( x1 x2 -- x2 x1 ) swap top 2 cells of the stack */
@ -----------------------------------------------------------------------------
  ldr r1,  [psp]  @ Load X from the stack, no SP change.
  str tos, [psp]  @ Replace it with TOS.
  movs tos, r1    @ And vice versa.
  NEXT
END SWAP
