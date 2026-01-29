@ -----------------------------------------------------------------------------
  CODEWORD "!", STORE @ ( x 32-addr -- )
  
  ands r0, tos, #0x3     /* cell aligned?         */
  beq  1f                /* branch if OK          */
  throw -9               /* not aligned so throw  */
1:                       /* normal operation      */ 
  ldm psp!, {r0, r1} @ X is the new TOS after the store completes.
  str r0, [tos]      @ Popping both saves a cycle.
  movs tos, r1
NEXT
