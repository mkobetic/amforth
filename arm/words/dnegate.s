@------------------------------------------------------------------------------
  CODEWORD "dnegate", DNEGATE /* ( d1 -- d2 ) d2 = -d1 */
@------------------------------------------------------------------------------

  bl dnegate
NEXT

dnegate:
  push {lr}
  ldr r0, [psp]
  movs r1, #0
  mvns r0, r0
  mvns tos, tos
  adds r0, #1
  adcs tos, r1
  str r0, [psp]
  pop {pc}
END DNEGATE
