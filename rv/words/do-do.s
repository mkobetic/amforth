# SPDX-License-Identifier: GPL-3.0-only
#HEADLESS DODO
HIDEWORD "(DODO)" , DODO
  # save loop sys
    addi s5, s5, -8
    sw s7, 4(s5)
    sw s8, 0(s5)
    # save loop limits and leave address on stack
    mv s7,s3
    loadtos
    mv s8,s3
    loadtos
    # 0x800000 magic
    li t1, 0x80000000
    add s8, s8, t1
    sub  s7, s7, s8
NEXT
