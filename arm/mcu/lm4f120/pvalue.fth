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

\ TODO: This should be called from warm after the normal value init runs,
\ and after the current arena is determined and pvarena is set.
\ The pvalues must be initialized with their default values first (like any values),
\ then this will replay all the pvalue records, ending up with the latest persisted state.
: pvalue.init ( -- ) \ replay pvarena records, set pvp
    pvarena cell+ cell+ \ TODO: skip the arena record for now
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

pvalue.init \ run init for pvalues
xx .
pvp .


