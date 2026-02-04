CODEWORD "2rot", 2ROT /* (x1 x2 x3 -- x2 x3 x1) rotate top 3 cells on stack left, 3OS becomes TOS (rot??) */
  popnos r0 @ x2
  popnos r1 @ x3
  pushnos r0 @ x2
  pushnos tos @ x1
  movs tos, r1 @ x3
  NEXT
END 2ROT
