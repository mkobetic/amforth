CODEWORD "2rot", 2ROT /* ( x3 x2 x1 -- x2 x1 x3 ) rotate x3 to be TOS */
  popnos r0 @ x2
  popnos r1 @ x3
  pushnos r0 @ x2
  pushnos tos @ x1
  movs tos, r1 @ x3
  NEXT
END 2ROT
