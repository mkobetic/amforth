# SPDX-License-Identifier: GPL-3.0-only
CONSTANT "trap.base" , TRAP_BASE , ram_vector_base
# ( -- u ) TRAP: beginning of Forth interrupt table

COLON "trap!" , TRAP_STORE
# ( xt n -- ) TRAP: store xt at trap number n in RAM vector
      .word XT_CELLS
      .word XT_TRAP_BASE
      .word XT_PLUS
      .word XT_STORE 
      .word XT_EXIT

