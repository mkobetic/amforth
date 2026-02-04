
CODEWORD  "up@", UP_FETCH /* ( -- addr ) addr is the user area pointer */
  savetos
  mov tos, up
  NEXT
END UP_FETCH

CODEWORD  "up!", UP_STORE /* ( addr -- ) set the user area pointer to addr */
  mov up, tos
  loadtos
  NEXT
END UP_STORE
