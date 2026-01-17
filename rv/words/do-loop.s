# SPDX-License-Identifier: GPL-3.0-only
#HEADLESS DOLOOP
HIDEWORD "(DOLOOP)" , DOLOOP
  li t0, 1
  j PFA_DOPLUSLOOP1

#HEADLESS DOPLUSLOOP
HIDEWORD "(DOPLUSLOOP)" , DOPLUSLOOP
  mv t0, s3
  loadtos
PFA_DOPLUSLOOP1:
  add t1,s7,t0
  slti t2,t0,0
  slt t3,t1,s7
  bne t2, t3, PFA_DOLOOP_LEAVE
  mv s7, t1
  lw s2,0(s2)
  NEXT
PFA_DOLOOP_LEAVE:
  # restore loop-sys
  lw s8, 0(s5)
  lw s7, 4(s5)
  addi s5, s5, 8

  # skip loop address
  addi s2,s2,4
NEXT
