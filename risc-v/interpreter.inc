# SPDX-License-Identifier: GPL-3.0-only
.global DO_EXECUTE

DOCOLON: 
        push s2   # IP
        mv s2,s1  # W->IP
DO_NEXT:
        lw s1, 0(s2) # @IP -> W 
        addi s2,s2,4 # INC IP
DO_EXECUTE:
        lw a0, 0(s1) # @W, address of some executable code
        addi s1,s1,4 # INC W, points now to PFA
        jalr zero,a0,0 # jump to code
#DO_EXECUTE:
#        lw   s10, 0(s1) # @W, address of some executable code
#        addi s1,s1,4 # INC W, points now to PFA
#        jalr zero,s10,0 # jump to code
