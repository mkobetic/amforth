# SPDX-License-Identifier: GPL-3.0-only
.global DO_EXECUTE , XT_WAZ


#
# all primitves / code words
# they are placed close together to
# maximize cache usage
#

    

.include "words/drop.s"
.include "words/over.s"
.include "words/swap.s"
.include "words/xor.s"
.include "words/umstar.s"

.include "words/plus.s"
.include "words/2drop.s"
.include "words/2dup.s"
.include "words/rot.s"
.include "words/invert.s"
.include "words/negate.s"
.include "words/minus.s"
.include "words/dnegate.s"
.include "words/d-plus.s"
.include "words/d-minus.s"
.include "words/star.s"


.include "mcu-words/flash.s"
.include "words/exit.s"
.include "words/exiti.s"

.include "words/dup.s"
.include "words/nip.s"

.include "words/q-dup.s"
.include "words/tuck.s"
.include "words/m-rot.s"
.include "words/pick.s"

.include "words/to-r.s"
.include "words/r-from.s"
.include "words/r-fetch.s"
.include "words/rp.s"
.include "words/sp.s"

.include "words/fetch.s"
.include "words/store.s"

#.include "words/negate.s"
.include "words/abs.s"
.include "words/muldiv.s"
.include "words/stack.s"
.include "words/logic.s"
.include "words/memory.s"

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

.include "words/comp.s"

.include "words/2swap.s"
.include "words/2nip.s"
#.include "words/2drop.s"
.include "words/2over.s"
.include "words/2r-fetch.s"
.include "words/2to-r.s"
.include "words/2r-from.s"
.include "words/d-2star.s"
.include "words/d-2slash.s"
#.include "words/dabs.s"
#.include "words/dnegate.s"
#.include "words/d-plus.s"
#.include "words/d-minus.s"
#.include "words/2dup.s"
.include "words/double.s"


#.include "words/umplus.s"
#.include "words/minus.s"
.include "words/1-plus.s"
.include "words/1-minus.s"
.include "words/2-plus.s"
.include "words/2-minus.s"
.include "words/2-star.s"
.include "words/2-slash.s"
.include "words/cell-plus.s"
.include "words/cells.s"


.include "words/tib.s"
.include "words/cold.s"

.include "words/execute.s"

#.include "words/pause.s"
.include "words/nop.s"


.include "words/do-do.s"
.include "words/do-loop.s"
.include "words/unloop.s"
.include "words/i.s"
.include "words/j.s"

.include "words/do-aligned.s"
.include "words/aligned.s"
#.include "words/aligned.s"
#.include "words/do-sliteral.s"
.include "words/do-variable.s"
.include "words/do-data.s"
.include "words/do-value.s"
.include "words/do-defer.s"
.include "words/do-user.s"
.include "words/do-does.k"
.include "words/up.s"

.include "words/1ms.s"
.include "words/dobranch.s"
.include "words/docondbranch.s"
.include "words/doliteral.s"
.include "words/doxliteral.s"
.include "words/compare.s"
.include "words/n_to_r.s"
.include "words/n_r_from.s"
.include "words/ashift.s"
.include "words/cell-minus.s"
#.include "words/areg.s"

.include "words/2rot.s"
#.include "words/pc.s"
.include "words/move.s"
.include "words/usb.s"
.include "words/wordswap.s"
