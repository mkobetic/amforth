# SPDX-License-Identifier: GPL-3.0-only
.global DO_EXECUTE , XT_WAZ


#
# all primitves / code words
# they are placed close together to
# maximize cache usage
#


.include "mcu-words/flash.s"
.include "pri-words/exit.s"
.include "pri-words/exiti.s"

.include "pri-words/drop.s"
.include "pri-words/swap.s"
.include "pri-words/dup.s"
.include "pri-words/nip.s"
.include "pri-words/over.s"
.include "pri-words/rot.s"
.include "pri-words/q-dup.s"
.include "pri-words/tuck.s"
.include "pri-words/m-rot.s"
.include "pri-words/pick.s"

.include "pri-words/to-r.s"
.include "pri-words/r-from.s"
.include "pri-words/r-fetch.s"
.include "pri-words/rp.s"
.include "pri-words/sp.s"

.include "pri-words/fetch.s"
.include "pri-words/store.s"

.include "pri-words/negate.s"
.include "pri-words/abs.s"
.include "pri-words/muldiv.s"
.include "pri-words/stack.s"
.include "pri-words/logic.s"
.include "pri-words/memory.s"

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

.include "pri-words/comp.s"

.include "pri-words/2swap.s"
.include "pri-words/2nip.s"
.include "pri-words/2drop.s"
.include "pri-words/2over.s"
.include "pri-words/2r-fetch.s"
.include "pri-words/2to-r.s"
.include "pri-words/2r-from.s"
.include "pri-words/d-2star.s"
.include "pri-words/d-2slash.s"
#.include "pri-words/dabs.s"
.include "pri-words/dnegate.s"
.include "pri-words/d-plus.s"
.include "pri-words/d-minus.s"
.include "pri-words/2dup.s"
.include "pri-words/double.s"

.include "pri-words/plus.s"
.include "pri-words/minus.s"
.include "pri-words/1-plus.s"
.include "pri-words/1-minus.s"
.include "pri-words/2-plus.s"
.include "pri-words/2-minus.s"
.include "pri-words/2-star.s"
.include "pri-words/2-slash.s"
.include "pri-words/cell-plus.s"
.include "pri-words/cells.s"


.include "pri-words/tib.s"
.include "pri-words/cold.s"

.include "pri-words/execute.s"

#.include "pri-words/pause.s"
.include "pri-words/nop.s"


.include "pri-words/do-do.s"
.include "pri-words/do-loop.s"
.include "pri-words/unloop.s"
.include "pri-words/i.s"
.include "pri-words/j.s"

.include "pri-words/aligned.s"
#.include "pri-words/do-sliteral.s"
.include "pri-words/do-variable.s"
.include "pri-words/do-data.s"
.include "pri-words/do-value.s"
.include "pri-words/do-defer.s"
.include "pri-words/do-user.s"
.include "pri-words/do-does.s"
.include "pri-words/up.s"

.include "pri-words/1ms.s"
.include "pri-words/dobranch.s"
.include "pri-words/docondbranch.s"
.include "pri-words/doliteral.s"
.include "pri-words/doxliteral.s"
.include "pri-words/compare.s"
.include "pri-words/n_to_r.s"
.include "pri-words/n_r_from.s"
.include "pri-words/ashift.s"
.include "pri-words/cell-minus.s"
.include "pri-words/areg.s"
#
# all secondaries / colon sec-words
# they represend data instead of code
#
# these move from pri-
.include "sec-words/dabs.s"
.include "sec-words/base.s"
.include "sec-words/state.s"
.include "sec-words/quit.s"
.include "sec-words/key.s"
.include "sec-words/keyq.s"
.include "sec-words/emit.s"
.include "sec-words/emitq.s"

.include "sec-words/pause.s"
.include "sec-words/bounds.s"
.include "sec-words/do-sliteral.s"
# end move

.include "sec-words/num-constants.s"
.include "sec-words/dicthelp.s"
.include "sec-words/warm.s"
.include "sec-words/ms.s"
.include "sec-words/cr.s"
.include "sec-words/bl.s"
.include "sec-words/space.s"
.include "sec-words/spaces.s"
.include "sec-words/left-bracket.s"
.include "sec-words/l-paren.s"
.include "sec-words/decimal.s"
.include "sec-words/hex.s"

.include "sec-words/pad.s"
.include "sec-words/here.s"
.include "sec-words/ramhere.s"
.include "sec-words/allot.s"

.include "sec-words/hold.s"
.include "sec-words/sharp.s"
.include "sec-words/sign.s"
.include "sec-words/dot.s"
.include "sec-words/d-dot-r.s"
.include "sec-words/d-dot.s"
.include "sec-words/u-dot.s"
.include "sec-words/ud-dot.s"
.include "sec-words/ud-dot-r.s"

.include "sec-words/dot-s.s"
.include "sec-words/dot-k.s"

.include "sec-words/refill.s"
.include "sec-words/accept.s"
.include "sec-words/prompt-error.s"
.include "sec-words/prompt-input.s"
.include "sec-words/prompt-ok.s"
.include "sec-words/prompt-ready.s"

.include "sec-words/catch.s"
.include "sec-words/throw.s"
.include "sec-words/source.s"
.include "sec-words/q-stack.s"
.include "sec-words/cscan.s"
.include "sec-words/cskip.s"
.include "sec-words/parse-name.s"
.include "sec-words/parse.s"
.include "sec-words/slash-string.s"

.include "sec-words/2literal.s"
.include "sec-words/literal.s"
.include "sec-words/xliteral.s"
.include "sec-words/compile.s"
.include "sec-words/comma.s"
.include "sec-words/immediate-q.s"
.include "sec-words/order.s"
.include "sec-words/find-xt.s"
.include "sec-words/xt2nfa.s"
.include "sec-words/xt2ffa.s"
.include "sec-words/nfa2lfa.s"
.include "sec-words/nfa2cfa.s"
.include "sec-words/traverse-wordlist.s"
.include "sec-words/show-wordlist.s"
.include "sec-words/current.s"
.include "sec-words/search-wordlist.s"
.include "sec-words/name2string.s"
.include "sec-words/name2flags.s"

.include "sec-words/mplus.s"
.include "sec-words/ud-star.s"
.include "sec-words/within.s"
.include "sec-words/to-upper.s"
.include "sec-words/digit-q.s"
.include "sec-words/to-number.s"
.include "sec-words/number.s"
.include "sec-words/q-sign.s"
.include "sec-words/set-base.s"
.include "sec-words/rec-null.s"
.include "sec-words/rec-find.s"
.include "sec-words/rec-intnum.s"
.include "sec-words/rec-split.s"
.include "sec-words/forth-recognizer.s"
.include "sec-words/recognize.s"

.include "sec-words/interpret.s"
.include "sec-words/map-stack.s"
.include "sec-words/qdo.s"

.include "sec-words/init-ram.s"
.include "sec-words/ver.s"

.include "sec-words/count.s"
.include "sec-words/type.s"
.include "sec-words/squote.s"
.include "sec-words/dot-quote.s"
.include "sec-words/scomma.s"
.include "sec-words/sliteral.s"
.include "sec-words/words.s"

.include "sec-words/l-mark.s"
.include "sec-words/l-resolve.s"
.include "sec-words/g-mark.s"
.include "sec-words/g-resolve.s"
.include "sec-words/ahead.s"
.include "sec-words/begin.s"
.include "sec-words/then.s"
.include "sec-words/until.s"
.include "sec-words/while.s"
.include "sec-words/if.s"
.include "sec-words/else.s"
.include "sec-words/again.s"
.include "sec-words/repeat.s"
.include "sec-words/leave.s"
.include "sec-words/immediate.s"
.include "sec-words/turnkey.s"

.include "sec-words/tick.s"
.include "sec-words/abort.s"

.include "sec-words/abort-string.s"
.include "sec-words/backslash.s"
.include "sec-words/bracketchar.s"
.include "sec-words/bracketcompile.s"
.include "sec-words/brackettick.s"
.include "sec-words/char.s"
.include "sec-words/colon-noname.s"
.include "sec-words/constant.s"
.include "sec-words/create.s"
.include "sec-words/defer-fetch.s"
.include "sec-words/defer-store.s"
.include "sec-words/do-create.s"
.include "sec-words/do.s"
.include "sec-words/endloop.s"
.include "sec-words/header.s"
.include "sec-words/latest.s"
.include "sec-words/loop.s"
.include "sec-words/newest.s"
.include "sec-words/plusloop.s"
.include "sec-words/postpone.s"
.include "sec-words/q-abort.s"
.include "sec-words/recurse.s"
.include "sec-words/reveal.s"
.include "sec-words/right-bracket.s"
.include "sec-words/colon.s"
.include "sec-words/semicolon.s"
.include "sec-words/semicoloni.s"
.include "sec-words/to.s"
.include "sec-words/variable.s"
.include "sec-words/wlscope.s"
.include "sec-words/to-body.s"
.include "sec-words/get-current.s"
.include "sec-words/greater-zero.s"
.include "sec-words/to-in.s"
.include "sec-words/dp.s"
.include "sec-words/udefer.s"
.include "sec-words/wordlist.s"
.include "sec-words/ramwordlist.s"



# TW testing 

#.include "sec-words/show.s"
.include "sec-words/val.s"
.include "sec-words/mop.s"
.include "sec-words/traps.s"
#.include "sec-words/forget.s"

.include "sec-words/dump.s"
.include "sec-words/testing.s"

#.include "sec-words/dis-asm.s"
#.include "sec-words/see.s"

#.include "sec-words/barbar.s"
#.include "sec-words/match.s"
#.include "sec-words/save.s"
#.include "sec-words/empty.s"





# .include "words/constants.s"
.include "mcu-words/gpio.s"
# MFD wrong chip .include "mcu-words/pll.s"
.include "mcu-words/usart.s"
# MFD wrong chip .include "mcu-words/qspidiv.s"

# MFD include "mcu-words/flash.s" as in dict_prims
.include "mcu-words/led.s"


.include "mcu-words/env-board.s"
.include "mcu-words/build-info.s"
.include "mcu-words/applturnkey.s"

.include "mcu-words/type0.s" # not sure 

# MFD .include "mcu-words/dump.s" as in dict_sec i think
# MFD .include "mcu-words/plop.s"

# MFD .include "mcu-words/qtest.s"
#.include "mcu-words/systick.s"
#.include "mcu-words/reset.s"
#.include "mcu-words/t6.s"
#.include "mcu-words/usb.s"


.include "env-words/env-forthname.s"
.include "env-words/env-forthversion.s"
.include "env-words/env-cpu.s"
.include "env-words/env-usersize.s"
