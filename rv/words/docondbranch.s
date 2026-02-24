# SPDX-License-Identifier: GPL-3.0-only
HEADLESS "(?branch)", DOCONDBRANCH
    addi t0,s3,0
    loadtos
    beq zero,t0,PFA_DOBRANCH
    addi s2,s2,4
    NEXT
END DOCONDBRANCH
