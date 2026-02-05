\ Make sure the arenas are "erased" to the expected blank flash state
pvarena1 pvasize $ff fill
pvarena2 pvasize $ff fill

\ Updating a pvalue means writing a new pvalue record in the current pvarena,
\ and then updating the corresponding RAM cell with the same value.
: pvstore.df ( x addr -- ) \ update pvalue with RAM address addr to value x
    \ write address as the record ID
    dup pvp !df \ store addr at pvp
    over pvp cell+ tuck \ ( x addr pvp+ x pvp+ )
    !df \ store x at pvp+
    cell+ to pvp \ update pvp to pvp++
    ! \ update ram
;

\ TODO: This should not be necessary once pvstore.df is hardcoded into pvalue definition.
' pvstore.df is pvstore

\ TODO: This should be called from warm after the normal value init runs,
\ and after the current arena is determined and pvarena is set.
\ The pvalues must be initialized with their default values first (like any values),
\ then this will replay all the pvalue records, ending up with the latest persisted state.
: pvalue.init ( -- ) \ replay pvarena records, set pvp
    pvarena cell+ cell+ \ TODO: skip the arena record for now
    begin
    dup @df dup 1+ while \ if record id is not all 1 bits, i.e. -1
        \ ( pvp pv-ram )
        swap cell+ tuck @df \ (pvp+ pv-ram pv-val)
        swap ! \ update pvalue in RAM
        cell+ \ ( pvp++ )
    repeat
    is pvp \ update pvp
;
