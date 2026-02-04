
@------------------------------------------------------------------------------
  CODEWORD  "fill", FILL /* ( addr n c -- ) fill n bytes from addr with c */
@------------------------------------------------------------------------------
  poptos r0 @ filler
  poptos r1 @ count
  @ TOS      Destination

  cbz r1, 2f
1:
  subs r1, #1
  strb r0, [tos, r1]
  bne 1b
2:
  loadtos
  NEXT
END FILL

@ -----------------------------------------------------------------------------
  CODEWORD  "+!", PLUSSTORE /* ( n addr -- ) add n to the memory cell at addr */
@ -----------------------------------------------------------------------------
  ldm psp!, {r0, r1} @ X is the new TOS after the store completes.
  ldr  r2, [tos]     @ Load the current cell value
  adds r2, r0        @ Do the add
  str  r2, [tos]     @ Store it back
  movs tos, r1
  NEXT
END PLUSSTORE

@ -----------------------------------------------------------------------------
  CODEWORD  "c@", CFETCH /* ( addr -- c ) load byte at addr */
@ -----------------------------------------------------------------------------
  ldrb tos, [tos]
  NEXT
END CFETCH

@ -----------------------------------------------------------------------------
  CODEWORD  "c!", CSTORE /* ( c addr -- ) store byte c to addr */
@ -----------------------------------------------------------------------------
  ldm psp!, {r0, r1} @ X is the new TOS after the store completes.
  strb r0, [tos]     @ Popping both saves a cycle.
  movs tos, r1
  NEXT
END CSTORE

# -----------------------------------------------------------------------------
CODEWORD  "h@", HFETCH /* ( addr -- x ) load halfword at addr */
# -----------------------------------------------------------------------------
  ldrh tos, [tos]
  NEXT
END HFETCH

# -----------------------------------------------------------------------------
  CODEWORD  "h!", HSTORE /* ( x addr -- ) store halfword to addr */
# -----------------------------------------------------------------------------
  popnos r0
  strh r0, [tos]
  loadtos
  NEXT
END HSTORE
