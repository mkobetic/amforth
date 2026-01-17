# SPDX-License-Identifier: GPL-3.0-only
CODEWORD "n>r", N_TO_R
    mv t0, s3
    mv t1, s3
N_TO_R_LOOP:
    loadtos
    push s3
    addi t0,t0,-1
    bne t0,zero,N_TO_R_LOOP
    push t1
    loadtos
NEXT
