CODEWORD "-rot", MROT /* (x1 x2 x3 -- x3 x1 x2) rotate top 3 cells on stack right, TOS becomes 3OS */
  mov r1, tos @ n3
  popnos tos @ n2
  popnos r0 @ n1
  pushnos r1
  pushnos r0
  NEXT
END MROT
