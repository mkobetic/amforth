# SPDX-License-Identifier: GPL-3.0-only
CODEWORD "nr>", N_R_FROM
    pop t0
    mv t1, t0
    savetos
N_R_FROM_LOOP:
    pop s3
    savetos
    addi t0,t0,-1
    bne t0,zero,N_R_FROM_LOOP
    mv s3, t1
NEXT
