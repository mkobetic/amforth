@ -----------------------------------------------------------------------------
  CODEWORD  "xor",XOR @ ( x1 x2 -- x1|x2 )
                        @ Combines the top two stack elements using bitwise exclusive-OR.
@ -----------------------------------------------------------------------------
  ldm psp!, {r0}
  eors tos, r0
  NEXT
