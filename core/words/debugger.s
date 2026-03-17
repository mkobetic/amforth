#======================================================================
#======================================================================
# transpiling ../amforth/lib/backtrace.frt on 2026/03/16 23:15:21
# : ?ip \# ( a -- f ) is a likely to be a valid IP address
# \# i.e. is it within the address ranges where words are compiled
#     dup flash.low memmode if dp else dp.flash then within if
#         drop true
#     else
#         dp0.ram memmode if dp.ram else dp then within
#     then
# ;
# 
# \ ' ?ip @ constant docolon
# 
# : ?xt \# ( a -- f ) is a likely an XT
#     @ docolon =
# ;
# 
# : ip2xt \# ( a -- xt u true | a false ) convert IP to the XT of its containing word, u = a - xt (in cells)
#     dup ?ip not if false exit then \# leave a as is if not an IP address
#     #100 0 do ( a ) \# don't go more than 100 cells back
#         dup ?xt if ( xt )
#             i true
#             unloop exit
#         then ( a )
#         cell-
#     loop ( a )
#     false
# ;
# 
# : ip2name \# ( a -- u s true | u a false ) convert IP a to the name of its containing word, u = a - xt (in cells)
#     ip2xt if ( xt u )
#         swap dup xt>nfa ?dup if ( u xt nfa )
#             dup @ 3 = if ( u xt nfa )
#                 drop false \# noname, return xt
#             else ( u xt nfa )
#                 nip nfa>string true
#             then
#         else ( u xt ) \# nfa not found
#             false
#         then
#     else ( a ) \# xt not found
#         0 swap false
#     then
# ;
# 
# : dbg.d. \# ( n -- ) print n in base 10
#     base @ swap #10 base ! . base !
# ;
# 
# : dbg.uh. \# ( u -- ) print u in base 16
#     base @ swap #16 base ! u. base !
# ;
# 
# 
# : .bt \# ( u -- ) print return stack (top first) skipping top u cells, use word names
#     rdepth over - dup 0 <= if 2drop exit then ( u depth )
#     swap cells rp@ + swap 0 ?do ( a )
#         dup @ ip2name if
#             type
#         else over if 8x. else dbg.uh. then
#         then ( a u )
#         ?dup if #43 emit dbg.d. then ( a )
#     cell+ loop
#     drop
# ;
# 
# : .rs \# ( u -- ) print return stack (top first) skipping top u cells, use raw IP addresses
#     rdepth over - dup 0 <= if 2drop exit then ( u depth )
#     swap cells rp@ + swap 0 ?do dup @ . cell+ loop
#     drop
# ;
# 
# : .itc \# ( u1 u2 -- ) dump u1 XTs starting from current IP u2 cells down the return stack
#     rdepth over - 0 <= if 2drop drop exit then
#     cells rp@ + @ ( u1 ip ) \# get the IP
#     swap 0 ?do ( ip )
#         s" |D " type dup 8x. space dup @ dup 8x. space xt>string type
#         i 0= if s"    <<(IP)<<" type then
#         cr cell+
#     loop
#     drop
# ;
# 
# \ testing words
# \ : tt ?dup if 1- recurse else 0 break then ;
# \ : fib
# \     break
# \     dup 2 <= if drop 1 exit then
# \     dup 1- recurse swap 1- 1- recurse +
# \ ;
# 
# \ debug.next[1:0] denotes the next debug action, 0 means no action
# \ debug.next[31:2] is action specific argument value
# \ debug actions
# 1 constant debug.step    \# single step, no argument
# 2 constant debug.rdepth  \# step until rdepth, argument is desired rdepth
# 
# : debugger \# ( -- ) implements debug actions
#     debug.next @ 2 and if \# is next action step until rdepth ?
#         debug.next @ 2 rshift rdepth < if
#             (exitd) \# rdepth is more than desired, keep going
#         then
#     then
#     \# emit stack state
#     s" |D PS: " type .s cr
#     s" |D RS: " type 1 .bt cr
#     5 1 .itc .ok .ready
#     begin
#         \# receive input from user
#         debug_buf dup refill-buf-size accept cr \# ( s )
#         \# (c)ontinue - resume normal execution
#         2dup s" c" compare not if 2drop
#             0 debug.next ! (exitd) then
#         \# (s)tep - single interpreter cycle
#         2dup s" s" compare not if 2drop
#             debug.step debug.next ! (exitd) then
#         \# (n)ext - step until we're back in the same word
#         2dup s" n" compare not if 2drop
#             rdepth 2 lshift debug.rdepth or debug.next ! (exitd) then
#         \# (r)eturn - step until we're out of current word
#         2dup s" r" compare not if 2drop
#             rdepth 1- 2 lshift debug.rdepth or debug.next ! (exitd) then
#         \# ( s ) otherwise evaluate the expression and repeat
#         (evaluate) .ok .ready
#     again
# ;d
# 
# : debug+ \# ( -- ) enable debugger, break will interrupt execution
#     ['] debugger debug.break ! ;
# 
# : debug- \# ( -- ) disable debugger, break will do nothing
#     0 debug.break ! ;
# 
# \ debug+

# ----------------------------------------------------------------------
COLON "?ip", QIP /* ( a -- f ) is a likely to be a valid IP address */
/* i.e. is it within the address ranges where words are compiled */
	.word XT_DUP
	.word XT_FLASH_LOW
	.word XT_MEMMODE
	.word XT_DOCONDBRANCH,QIP_0001 /* if */
	.word XT_DP
	.word XT_DOBRANCH,QIP_0002
QIP_0001: /* else */
	.word XT_DP_FLASH
QIP_0002: /* then */
	.word XT_WITHIN
	.word XT_DOCONDBRANCH,QIP_0003 /* if */
	.word XT_DROP
	.word XT_TRUE
	.word XT_DOBRANCH,QIP_0004
QIP_0003: /* else */
	.word XT_DP0DOTRAM
	.word XT_MEMMODE
	.word XT_DOCONDBRANCH,QIP_0005 /* if */
	.word XT_DP_RAM
	.word XT_DOBRANCH,QIP_0006
QIP_0005: /* else */
	.word XT_DP
QIP_0006: /* then */
	.word XT_WITHIN
QIP_0004: /* then */
	.word XT_EXIT
END QIP
# ----------------------------------------------------------------------
COLON "?xt", QXT /* ( a -- f ) is a likely an XT */
	.word XT_FETCH
	.word XT_DOCOLON
	.word XT_EQUAL
	.word XT_EXIT
END QXT
# ----------------------------------------------------------------------
COLON "ip2xt", IP2XT /* ( a -- xt u true | a false ) convert IP to the XT of its containing word, u = a - xt (in cells) */
	.word XT_DUP
	.word XT_QIP
	.word XT_NOT
	.word XT_DOCONDBRANCH,IP2XT_0001 /* if */
	.word XT_FALSE
	.word XT_FINISH
IP2XT_0001: /* then */
/* leave a as is if not an IP address */
	.word XT_DOLITERAL
	.word 100
	.word XT_ZERO
	.word XT_DODO
IP2XT_0003: /* do */
/* don't go more than 100 cells back */
	.word XT_DUP
	.word XT_QXT
	.word XT_DOCONDBRANCH,IP2XT_0004 /* if */
	.word XT_I
	.word XT_TRUE
	.word XT_UNLOOP
	.word XT_FINISH
IP2XT_0004: /* then */
	.word XT_CELLMINUS
	.word XT_DOLOOP,IP2XT_0003 /* loop */
IP2XT_0002: /* (for ?do IF required) */
	.word XT_FALSE
	.word XT_EXIT
END IP2XT
# ----------------------------------------------------------------------
COLON "ip2name", IP2NAME /* ( a -- u s true | u a false ) convert IP a to the name of its containing word, u = a - xt (in cells) */
	.word XT_IP2XT
	.word XT_DOCONDBRANCH,IP2NAME_0001 /* if */
	.word XT_SWAP
	.word XT_DUP
	.word XT_XT2NFA
	.word XT_QDUP
	.word XT_DOCONDBRANCH,IP2NAME_0002 /* if */
	.word XT_DUP
	.word XT_FETCH
	.word XT_DOLITERAL
	.word 3
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,IP2NAME_0003 /* if */
	.word XT_DROP
	.word XT_FALSE
/* noname, return xt */
	.word XT_DOBRANCH,IP2NAME_0004
IP2NAME_0003: /* else */
	.word XT_NIP
	.word XT_NFA2STRING
	.word XT_TRUE
IP2NAME_0004: /* then */
	.word XT_DOBRANCH,IP2NAME_0005
IP2NAME_0002: /* else */
/* nfa not found */
	.word XT_FALSE
IP2NAME_0005: /* then */
	.word XT_DOBRANCH,IP2NAME_0006
IP2NAME_0001: /* else */
/* xt not found */
	.word XT_ZERO
	.word XT_SWAP
	.word XT_FALSE
IP2NAME_0006: /* then */
	.word XT_EXIT
END IP2NAME
# ----------------------------------------------------------------------
COLON "dbg.d.", DBGDOTDDOT /* ( n -- ) print n in base 10 */
	.word XT_BASE
	.word XT_FETCH
	.word XT_SWAP
	.word XT_DOLITERAL
	.word 10
	.word XT_BASE
	.word XT_STORE
	.word XT_DOT
	.word XT_BASE
	.word XT_STORE
	.word XT_EXIT
END DBGDOTDDOT
# ----------------------------------------------------------------------
COLON "dbg.uh.", DBGDOTUHDOT /* ( u -- ) print u in base 16 */
	.word XT_BASE
	.word XT_FETCH
	.word XT_SWAP
	.word XT_DOLITERAL
	.word 16
	.word XT_BASE
	.word XT_STORE
	.word XT_UDOT
	.word XT_BASE
	.word XT_STORE
	.word XT_EXIT
END DBGDOTUHDOT
# ----------------------------------------------------------------------
COLON ".bt", DOTBT /* ( u -- ) print return stack (top first) skipping top u cells, use word names */
	.word XT_RDEPTH
	.word XT_OVER
	.word XT_MINUS
	.word XT_DUP
	.word XT_ZERO
	.word XT_LESSEQUAL
	.word XT_DOCONDBRANCH,DOTBT_0001 /* if */
	.word XT_2DROP
	.word XT_FINISH
DOTBT_0001: /* then */
	.word XT_SWAP
	.word XT_CELLS
	.word XT_RP_FETCH
	.word XT_PLUS
	.word XT_SWAP
	.word XT_ZERO
	.word XT_QDOCHECK, XT_DOCONDBRANCH,DOTBT_0002 /* ?do */
	.word XT_DODO
DOTBT_0003: /* do */
	.word XT_DUP
	.word XT_FETCH
	.word XT_IP2NAME
	.word XT_DOCONDBRANCH,DOTBT_0004 /* if */
	.word XT_TYPE
	.word XT_DOBRANCH,DOTBT_0005
DOTBT_0004: /* else */
	.word XT_OVER
	.word XT_DOCONDBRANCH,DOTBT_0006 /* if */
	.word XT_8XDOT
	.word XT_DOBRANCH,DOTBT_0007
DOTBT_0006: /* else */
	.word XT_DBGDOTUHDOT
DOTBT_0007: /* then */
DOTBT_0005: /* then */
	.word XT_QDUP
	.word XT_DOCONDBRANCH,DOTBT_0008 /* if */
	.word XT_DOLITERAL
	.word 43
	.word XT_EMIT
	.word XT_DBGDOTDDOT
DOTBT_0008: /* then */
	.word XT_CELLPLUS
	.word XT_DOLOOP,DOTBT_0003 /* loop */
DOTBT_0002: /* (for ?do IF required) */
	.word XT_DROP
	.word XT_EXIT
END DOTBT
# ----------------------------------------------------------------------
COLON ".rs", DOTRS /* ( u -- ) print return stack (top first) skipping top u cells, use raw IP addresses */
	.word XT_RDEPTH
	.word XT_OVER
	.word XT_MINUS
	.word XT_DUP
	.word XT_ZERO
	.word XT_LESSEQUAL
	.word XT_DOCONDBRANCH,DOTRS_0001 /* if */
	.word XT_2DROP
	.word XT_FINISH
DOTRS_0001: /* then */
	.word XT_SWAP
	.word XT_CELLS
	.word XT_RP_FETCH
	.word XT_PLUS
	.word XT_SWAP
	.word XT_ZERO
	.word XT_QDOCHECK, XT_DOCONDBRANCH,DOTRS_0002 /* ?do */
	.word XT_DODO
DOTRS_0003: /* do */
	.word XT_DUP
	.word XT_FETCH
	.word XT_DOT
	.word XT_CELLPLUS
	.word XT_DOLOOP,DOTRS_0003 /* loop */
DOTRS_0002: /* (for ?do IF required) */
	.word XT_DROP
	.word XT_EXIT
END DOTRS
# ----------------------------------------------------------------------
COLON ".itc", DOTITC /* ( u1 u2 -- ) dump u1 XTs starting from current IP u2 cells down the return stack  */
	.word XT_RDEPTH
	.word XT_OVER
	.word XT_MINUS
	.word XT_ZERO
	.word XT_LESSEQUAL
	.word XT_DOCONDBRANCH,DOTITC_0001 /* if */
	.word XT_2DROP
	.word XT_DROP
	.word XT_FINISH
DOTITC_0001: /* then */
	.word XT_CELLS
	.word XT_RP_FETCH
	.word XT_PLUS
	.word XT_FETCH
/* get the IP */
	.word XT_SWAP
	.word XT_ZERO
	.word XT_QDOCHECK, XT_DOCONDBRANCH,DOTITC_0002 /* ?do */
	.word XT_DODO
DOTITC_0003: /* do */
	STRING "|D "
	.word XT_TYPE
	.word XT_DUP
	.word XT_8XDOT
	.word XT_SPACE
	.word XT_DUP
	.word XT_FETCH
	.word XT_DUP
	.word XT_8XDOT
	.word XT_SPACE
	.word XT_XT2STRING
	.word XT_TYPE
	.word XT_I
	.word XT_ZEROEQUAL
	.word XT_DOCONDBRANCH,DOTITC_0004 /* if */
	STRING "   <<(IP)<<"
	.word XT_TYPE
DOTITC_0004: /* then */
	.word XT_CR
	.word XT_CELLPLUS
	.word XT_DOLOOP,DOTITC_0003 /* loop */
DOTITC_0002: /* (for ?do IF required) */
	.word XT_DROP
	.word XT_EXIT
END DOTITC
# ----------------------------------------------------------------------
CONSTANT "debug.step",DEBUGDOTSTEP,1
END DEBUGDOTSTEP
/* single step, no argument */
CONSTANT "debug.rdepth",DEBUGDOTRDEPTH,2
END DEBUGDOTRDEPTH
/* step until rdepth, argument is desired rdepth */
# ----------------------------------------------------------------------
COLON "debugger", DEBUGGER /* ( -- ) implements debug actions */
	.word XT_DEBUG_NEXT
	.word XT_FETCH
	.word XT_TWO
	.word XT_AND
	.word XT_DOCONDBRANCH,DEBUGGER_0001 /* if */
/* is next action step until rdepth ? */
	.word XT_DEBUG_NEXT
	.word XT_FETCH
	.word XT_TWO
	.word XT_RSHIFT
	.word XT_RDEPTH
	.word XT_LESS
	.word XT_DOCONDBRANCH,DEBUGGER_0002 /* if */
	.word XT_EXITD
/* rdepth is more than desired, keep going */
DEBUGGER_0002: /* then */
DEBUGGER_0001: /* then */
/* emit stack state */
	STRING "|D PS: "
	.word XT_TYPE
	.word XT_DOTS
	.word XT_CR
	STRING "|D RS: "
	.word XT_TYPE
	.word XT_ONE
	.word XT_DOTBT
	.word XT_CR
	.word XT_DOLITERAL
	.word 5
	.word XT_ONE
	.word XT_DOTITC
	.word XT_PROMPTOK
	.word XT_PROMPTREADY
DEBUGGER_0003: /* begin */
/* receive input from user */
	.word XT_DEBUG_BUF
	.word XT_DUP
	.word XT_REFILL_BUF_SIZE
	.word XT_ACCEPT
	.word XT_CR
/* ( s ) */
/* (c)ontinue - resume normal execution */
	.word XT_2DUP
	STRING "c"
	.word XT_COMPARE
	.word XT_NOT
	.word XT_DOCONDBRANCH,DEBUGGER_0004 /* if */
	.word XT_2DROP
	.word XT_ZERO
	.word XT_DEBUG_NEXT
	.word XT_STORE
	.word XT_EXITD
DEBUGGER_0004: /* then */
/* (s)tep - single interpreter cycle */
	.word XT_2DUP
	STRING "s"
	.word XT_COMPARE
	.word XT_NOT
	.word XT_DOCONDBRANCH,DEBUGGER_0005 /* if */
	.word XT_2DROP
	.word XT_DEBUGDOTSTEP
	.word XT_DEBUG_NEXT
	.word XT_STORE
	.word XT_EXITD
DEBUGGER_0005: /* then */
/* (n)ext - step until we're back in the same word */
	.word XT_2DUP
	STRING "n"
	.word XT_COMPARE
	.word XT_NOT
	.word XT_DOCONDBRANCH,DEBUGGER_0006 /* if */
	.word XT_2DROP
	.word XT_RDEPTH
	.word XT_TWO
	.word XT_LSHIFT
	.word XT_DEBUGDOTRDEPTH
	.word XT_OR
	.word XT_DEBUG_NEXT
	.word XT_STORE
	.word XT_EXITD
DEBUGGER_0006: /* then */
/* (r)eturn - step until we're out of current word */
	.word XT_2DUP
	STRING "r"
	.word XT_COMPARE
	.word XT_NOT
	.word XT_DOCONDBRANCH,DEBUGGER_0007 /* if */
	.word XT_2DROP
	.word XT_RDEPTH
	.word XT_1MINUS
	.word XT_TWO
	.word XT_LSHIFT
	.word XT_DEBUGDOTRDEPTH
	.word XT_OR
	.word XT_DEBUG_NEXT
	.word XT_STORE
	.word XT_EXITD
DEBUGGER_0007: /* then */
/* ( s ) otherwise evaluate the expression and repeat */
	.word XT_LPARENEVALUATERPAREN
	.word XT_PROMPTOK
	.word XT_PROMPTREADY
	.word XT_DOBRANCH,DEBUGGER_0003 /* again */
	.word XT_SEMICOLOND
# ----------------------------------------------------------------------
COLON "debug+", DEBUGPLUS /* ( -- ) enable debugger, break will interrupt execution */
	.word XT_DOXLITERAL
	.word XT_DEBUGGER
	.word XT_DEBUG_BREAK
	.word XT_STORE
	.word XT_EXIT
END DEBUGPLUS
# ----------------------------------------------------------------------
COLON "debug-", DEBUGMINUS /* ( -- ) disable debugger, break will do nothing */
	.word XT_ZERO
	.word XT_DEBUG_BREAK
	.word XT_STORE
	.word XT_EXIT
END DEBUGMINUS
# ----------------------------------------------------------------------
#=====================================================================
#======================================================================
