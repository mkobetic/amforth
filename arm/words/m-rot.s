CODEWORD "-rot", MROT /* (n1 n2 n3 -- n3 n1 n2) rotate stack so that TOS is at 3 */
  mov r1, tos @ n3
  popnos tos @ n2
  popnos r0 @ n1
  pushnos r1
  pushnos r0
  NEXT
END MROT
