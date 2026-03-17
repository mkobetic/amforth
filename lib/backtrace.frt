: ?ip \# ( a -- f ) is a likely to be a valid IP address
\# i.e. is it within the address ranges where words are compiled
    dup flash.low memmode if dp else dp.flash then within if
        drop true
    else
        dp0.ram memmode if dp.ram else dp then within
    then
;

: ip2xt \# ( a -- xt u true | a false ) convert IP to the XT of its containing word, u = a - xt (in cells)
    dup ?ip not if false exit then \# leave a as is if not an IP address
    #100 0 do ( a ) \# don't go more than 100 cells back
        dup colon? if ( xt )
            i true
            unloop exit
        then ( a )
        cell-
    loop ( a )
    false
;

: ip2name \# ( a -- u s true | u a false ) convert IP a to the name of its containing word, u = a - xt (in cells)
    ip2xt if ( xt u )
        swap dup xt>nfa ?dup if ( u xt nfa )
            dup @ 3 = if ( u xt nfa )
                drop false \# noname, return xt
            else ( u xt nfa )
                nip nfa>string true
            then
        else ( u xt ) \# nfa not found
            false
        then
    else ( a ) \# xt not found
        0 swap false
    then
;

: dbg.d. \# ( n -- ) print n in base 10
    base @ swap #10 base ! . base !
;

: dbg.uh. \# ( u -- ) print u in base 16
    base @ swap #16 base ! u. base !
;


: .bt \# ( u -- ) print return stack (top first) skipping top u cells, use word names
    rdepth over - dup 0 <= if 2drop exit then ( u depth )
    swap cells rp@ + swap 0 ?do ( a )
        dup @ ip2name if
            type
        else over if 8x. else dbg.uh. then
        then ( a u )
        ?dup if #43 emit dbg.d. then ( a )
    cell+ loop
    drop
;

: .rs \# ( u -- ) print return stack (top first) skipping top u cells, use raw IP addresses
    rdepth over - dup 0 <= if 2drop exit then ( u depth )
    swap cells rp@ + swap 0 ?do dup @ . cell+ loop
    drop
;

: .itc \# ( u1 u2 -- ) dump u1 XTs starting from current IP, skipping top u2 cells 
    rdepth over - 0 <= if 2drop drop exit then
    cells rp@ + @ ( u1 ip ) \# get the IP
    swap 0 ?do ( ip )
        s" |D " type dup 8x. space dup @ dup 8x. space xt>string type
        i 0= if s"    <<(IP)<<" type then
        cr cell+
    loop
    drop
;

\ testing words
\ : tt ?dup if 1- recurse else 0 break then ;
\ : fib 
\     break
\     dup 2 <= if drop 1 exit then 
\     dup 1- recurse swap 1- 1- recurse +
\ ;

\ debug.next[1:0] denotes the next debug action, 0 means no action
\ debug.next[31:2] is action specific argument value
\ debug actions
1 constant debug.step    \# single step, no argument
2 constant debug.rdepth  \# step until rdepth, argument is desired rdepth

: debugger \# ( -- ) implements debug actions
    debug.next @ 2 and if \# is next action step until rdepth ?
        debug.next @ 2 rshift rdepth < if 
            (exitd) \# rdepth is more than desired, keep going
        then
    then
    \# emit stack state
    s" |D PS: " type .s cr
    s" |D RS: " type 1 .bt cr
    5 1 .itc .ok .ready
    begin
        \# receive input from user
        debug_buf dup refill-buf-size accept cr \# ( s )
        \# (c)ontinue - resume normal execution
        2dup s" c" compare not if 2drop
            0 debug.next ! (exitd) then
        \# (s)tep - single interpreter cycle
        2dup s" s" compare not if 2drop
            debug.step debug.next ! (exitd) then
        \# (n)ext - step until we're back in the same word
        2dup s" n" compare not if 2drop
            rdepth 2 lshift debug.rdepth or debug.next ! (exitd) then
        \# (r)eturn - step until we're out of current word
        2dup s" r" compare not if 2drop
            rdepth 1- 2 lshift debug.rdepth or debug.next ! (exitd) then
        \# ( s ) otherwise evaluate the expression and repeat
        (evaluate) .ok .ready
    again
;d

: debug+ \# ( -- ) enable debugger, break will interrupt execution
    ['] debugger debug.break ! ;

: debug- \# ( -- ) disable debugger, break will do nothing
    0 debug.break ! ;

\ debug+
