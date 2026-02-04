# SPDX-License-Identifier: GPL-3.0-only

CODEWORD "unloop", UNLOOP /* (R: loop-sys -- ) remove loop-sys, exit the loop and continue execution after it */
    # restore loop-sys
    lw s8, 0(s5)
    lw s7, 4(s5)
    addi s5, s5, 8
    NEXT
END UNLOOP
