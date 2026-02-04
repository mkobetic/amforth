@ -----------------------------------------------------------------------------
  CODEWORD "@", FETCH /* (addr -- x) x = [addr]; load word at addr */
@ -----------------------------------------------------------------------------
  
  ands r0, tos, #0x3     /* cell aligned?         */
  beq  1f                /* branch if OK          */
  throw EADRINV          /* not aligned so throw  */
1:                       /* normal operation      */ 
  ldr tos, [tos]
  NEXT
END FETCH
