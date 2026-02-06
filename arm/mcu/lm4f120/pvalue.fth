\ Make sure the arenas are "erased" to the expected blank flash state
pvarena1 pvasize $ff fill
pvarena2 pvasize $ff fill

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
: pvarena.init ( -- ) \ set pvarena to whichever arena should be current ;
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

\ TODO: What follows is just a test script demonstrating the functionality
hex

\ show initial setup
pv.init
pvp .
pvarena .
pvarena 10 - 5 dump

\ create a value and update it persistently multiple times
42 value xx
xx .       \ value of xx
vaddr xx . \ RAM address of xx
1 pvto xx
xx .
2 pvto xx
xx .
3 pvto xx
xx .

pvarena 10 - 5 dump \ show the arena
pvp .

\ reset the value and pvp
0 is pvp
0 vaddr xx !
xx .

pv.init \ reinitialize pvalue system
xx .
pvp .


