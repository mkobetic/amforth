\ Updating a pvalue means writing a new pvalue record in the current pvarena,
\ and then updating the corresponding RAM cell with the same value.
: pvstore ( x addr -- ) \ update pvalue with RAM address addr to value x
    \ check that there is room in the current arena, throw otherwise
    pvarena pvasize + pvp <= if
        -8 throw \ TODO: -8 is dictionary overflow, probably want something better here
    then
    \ write pvalue RAM address as the record ID
    dup pvp !df \ store addr at pvp
    over pvp cell+ tuck \ ( x addr pvp+ x pvp+ )
    !df \ store x at pvp+
    cell+ to pvp \ update pvp to pvp++
    ! \ update ram
;

: vaddr ( "name" -- addr ) \ RAM address of value "name"
    ' >body @ ;

\ TODO: This is just for testing in the interpreter,
\ ITC will want to call PVSTORE with literal XTs of predefined flash values.
: pvto ( x "name" -- ) \ set value to x and write pvalue record for it
    vaddr pvstore ;

\ Arena state is stored in the first record of the arena.
\ First cell is a counter with MSB set (so that it doesn't match any real RAM address).
\ Second cell is either -1 or 0. Erased dormant arena has both cells set to -1.
\ Current arena is the one with higher ID that is not -1.
: pvarena.init ( -- ) \ set pvarena to whichever arena should be current
    pvarena1 @df dup 1+ if \ is arena1 dormant? (ID = -1)
        pvarena2 @df dup 1+ if \ is arena2 dormant?
            \ (a1id a2id) higher ID wins
            < if pvarena2 to pvarena
            else pvarena1 to pvarena
            then
        else \ arena2 is dormant ( a1id -1 )
            pvarena1 to pvarena
            2drop \ unused arena IDs
        then
    else \ arena1 is dormant ( -1 )
        pvarena2 @df 1+ if \ is arena2 dormant?
            pvarena2 to pvarena
        else \ arena2 is dormant
            \ both arenas are blank, initialize arena1 and use it.
            $80000000 pvarena1 !df
            0 pvarena1 cell+ !df
            pvarena1 to pvarena
        then
        drop \ unused arena1 ID
    then ;

\ TODO: This should be called from warm after the normal value init runs.
\ The pvalues must be initialized with their default values first (like any values),
\ then this will replay all the pvalue records, ending up with the latest persisted state.
: pv.init ( -- ) \ replay pvarena records, set pvp
    pvarena.init \ initialize pvarena
    pvarena cell+ cell+ \ skip the arena record
    begin
    dup @df dup 1+ while \ if record id is not all 1 bits, i.e. -1
        \ ( pvp pv-ram )
        swap cell+ tuck @df \ ( pvp+ pv-ram [pvp+] )
        swap ! \ update pvalue in RAM ( pvp+ )
        cell+ \ ( pvp++ )
    repeat
    \ ( pvp++ -1 )
    drop to pvp \ update pvp
;

: pvarena.dormant ( -- addr ) \ return address of the other arena
    pvarena1 pvarena = if pvarena2 else pvarena1 then
;

: pvarena.erase ( addr -- ) \ erase arena at addr from the end
    dup pvasize + pvpgsize -
    begin 2dup <= while
        dup df.erase
        pvpgsize - 
    repeat
    2drop
;

\ used to prepare dormant arena for arena swap
: pv.writeword ( awp ffa - awp++ ) \ write pvalue record at awp if ffa is pvalue, advance awp
    dup @ flag.pvalue and if
        ffa2cfa >body @ \ (awp pv-ram)
        2dup swap !df @ \ write record ID (awp [pv-ram] )
        swap cell+ tuck !df \ (awp+)
        cell+ \ (awp++)
    else drop \ drop the ffa (awp)
    then
    true
;

\ second cell of the arena record is written first to mark it dirty
\ if arena is dirty it is erased completely first (erase the first block last)
\ first cell of arena record is written last, with ID +1 of the active arena,
\ this marks the arena complete and active.
: pvarena.swap ( -- ) \ write fresh pvalues into the dormant arena and swap arenas
    pvarena.dormant 
    \ check if it needs to be erased
    dup cell+ dup @df 1+ 0<> if dup pvarena.erase then
    \ write dirty mark ( arena arena+ )
    dup 0 swap !df cell+ \ ( arena arena++ )
    \ write fresh record for each persistent value in forth-wordlist
    ['] pv.writeword forth-wordlist traverse-wordlist
    swap \ swap the arena pointers ( awp arena )
    \ write arena ID (this must happen last)
    dup pvarena @df 1+ swap !df
    \ swap arenas ( awp arena )
    pvarena swap ( awp old-arena new-arena )
    to pvarena swap \ set pvarena
    to pvp \ set pvp
    pvarena.erase \ erase old arena
;

\ TODO: What follows is just a test script demonstrating the functionality
hex

\ Make sure arenas are "erased" to the expected blank flash state
pvarena1 pvarena.erase
pvarena1 10 - 5 dump \ check arena1
pvarena2 pvarena.erase
pvarena2 10 - 5 dump \ check arena2

\ show initial setup
pv.init
pvp .
pvarena .
pvarena 10 - 5 dump

\ update pvalues multiple times
vaddr pv1 . \ RAM address of pv1
pv1 .       \ value of pv1
1 pvto pv1
pv1 .
2 pvto pv1
pv1 .

vaddr pv2 . \ RAM address of pv2
pv2 .       \ value of pv1
3 pvto pv2
pv2 .

4 pvto pv1
pv1 .

5 pvto pv2
pv2 .

pvarena 10 - 5 dump \ show the arena
pvp .

\ reset the values and pvp
0 is pvp
0 vaddr pv1 !
pv1 .

0 vaddr pv2 !
pv2 .


pv.init \ reinitialize pvalue system
pv1 .
pv2 .
pv3 .
pvp .

\ swap arenas
pvarena.swap
pvp .
pvarena .
pvarena 10 - 5 dump \ show the new arena
pvarena.dormant 10 - 5 dump \ show the old arena