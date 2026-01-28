/*
WORD: "-rot"
STACK: (n1 n2 n3 -- n3 n1 n2)
CATEG: STACK
SHORT: rotate stack so TOS at 3
*/

CODEWORD "-rot", MROT
  mov r1, tos @ n3
  popnos tos @ n2
  popnos r0 @ n1
  pushnos r1
  pushnos r0
NEXT
