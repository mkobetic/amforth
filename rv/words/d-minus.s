# SPDX-License-Identifier: GPL-3.0-only
.macro subc dest, sour1, sour2
  sub t2, \sour1, \sour2
  sltu s7, \sour1, \sour2
  sub \dest, t2, t0
  sltu s8, t2, t0
  or t0, s7, s8
.endm

#------------------------------------------------------------------------------
  CODEWORD  "d-", DMINUS # ( 1L 1H 2L 2H )
#------------------------------------------------------------------------------
  push a0

  lw t0, 8(s4)
  lw t1, 0(s4)

  sub a0, t0, t1
  sw a0, 8(s4)

  sltu a0, t0, t1

  lw t0, 4(s4)
  sub s3, t0, s3
  sub s3, s3, a0

  addi s4, s4, 8

  pop a0

  NEXT
