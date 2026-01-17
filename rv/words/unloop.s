# SPDX-License-Identifier: GPL-3.0-only

CODEWORD "unloop", UNLOOP
    # restore loop-sys
    lw s8, 0(s5)
    lw s7, 4(s5)
    addi s5, s5, 8
    NEXT
