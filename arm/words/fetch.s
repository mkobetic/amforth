@ -----------------------------------------------------------------------------
  CODEWORD "@", FETCH @ ( 32-addr -- x )
@ -----------------------------------------------------------------------------
  
  ands r0, tos, #0x3     /* cell aligned?         */
  beq  1f                /* branch if OK          */
  throw -9               /* not aligned so throw  */
1:                       /* normal operation      */ 
  ldr tos, [tos]
NEXT
