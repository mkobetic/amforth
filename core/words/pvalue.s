/* 
\ transpiling pval.f on 2026/02/06 18:38:12

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
\ ITC will want to call PV_STORE with literal XTs of predefined flash values.
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
*/

/* following deferred words are data flash primitives that need to be implemented by the MCU */

DEFER "!pvf", STORE_PVF, XT_STORE /* (x addr -- ) store x at addr in the PV flash */
END STORE_PVF

DEFER "@pvf", FETCH_PVF, XT_FETCH /* (addr -- x) load cell at addr in the PV flash */
END FETCH_PVF

DEFER "pvflash.erase", PVF_ERASE, XT_FAUXERASE /* ( addr -- ) erase PV flash page at addr */
END FETCH_PVF

NONAME FAUXERASE /* :noname pvpgsize $FF fill ; */
    .word XT_PVFLASH_SIZE, XT_FF, XT_FILL, XT_EXIT
END FAUXERASE

/* this is just a hack to avoid XT_DOLITERAL, 0xFF in FAUXERASE
 because it's insanely complicated to step through */
CONSTANT "ff", FF, 0xFF 

/* pvalue memory constants */

CONSTANT "pvarena1", PVARENA1, pvarena1_lower /* ( -- addr ) address of pvalue arena 1  */
END PVARENA1

CONSTANT "pvarena2", PVARENA2, pvarena2_lower /* ( -- addr ) address of pvalue arena 2  */
END PVARENA2

CONSTANT "pvarena.size", PVARENA_SIZE, pvarena.size /* ( -- u ) size of pvalue arena (multiple of flash page size) */
END PVARENA_SIZE

CONSTANT "pvflash.size", PVFLASH_SIZE, pvflash.page /* ( -- u ) size of arena page (flash page size) */
END PVFLASH_SIZE

/* pvalue runtime values, must be initialized by pv.init */

VALUE "pvp", PVP, 0 /* ( -- addr ) address of the next free cell in active arena */
END PVP

VALUE "pvarena", PVARENA, 0 /* ( -- addr ) start address of active arena */
END PVARENA

/* test pvalues */
PVALUE "pv1", PV1, 42
END PV1
PVALUE "pv2", PV2, 42
END PV2
PVALUE "pv3", PV3, 42
END PV3


# ----------------------------------------------------------------------

COLON "pv.store", PV_STORE /* ( x addr -- ) update pvalue with RAM address addr to value x */
/*  Updating a pvalue means writing a new pvalue record in the current pvarena,
    and then updating the corresponding RAM cell with the same value. */
	.word XT_PVARENA
	.word XT_PVARENA_SIZE
	.word XT_PLUS
	.word XT_PVP
	.word XT_LESSEQUAL
	.word XT_DOCONDBRANCH,PV_STORE_0001
	.word XT_DOLITERAL
	.word -8
	.word XT_THROW
PV_STORE_0001: # then
	.word XT_DUP
	.word XT_PVP
	.word XT_STORE_PVF
	.word XT_OVER
	.word XT_PVP
	.word XT_CELLPLUS
	.word XT_TUCK
	.word XT_STORE_PVF
	.word XT_CELLPLUS
	.word XT_DOTO
	.word XT_PVP
	.word XT_STORE
	.word XT_EXIT
END PV_STORE

# ----------------------------------------------------------------------

COLON "vaddr", VADDR /* ( "name" -- addr ) RAM address of value "name" */
	.word XT_TICK
	.word XT_TO_BODY
	.word XT_FETCH
	.word XT_EXIT
END VADDR

# ----------------------------------------------------------------------

COLON "pvarena.init", PVARENADOTINIT /* ( -- ) set pvarena to whichever arena should be current */
/*  Arena state is stored in the first record of the arena.
    First cell is a counter with MSB set (so that it doesn't match any real RAM address).
    Second cell is either -1 or 0. Erased dormant arena has both cells set to -1.
    Current arena is the one with higher ID that is not -1. */
	.word XT_PVARENA1
	.word XT_FETCH_PVF
	.word XT_DUP
	.word XT_1PLUS
	.word XT_DOCONDBRANCH,PVARENADOTINIT_0001
	.word XT_PVARENA2
	.word XT_FETCH_PVF
	.word XT_DUP
	.word XT_1PLUS
	.word XT_DOCONDBRANCH,PVARENADOTINIT_0002
	.word XT_LESS
	.word XT_DOCONDBRANCH,PVARENADOTINIT_0003
	.word XT_PVARENA2
	.word XT_DOTO
	.word XT_PVARENA
	.word XT_DOBRANCH,PVARENADOTINIT_0004
PVARENADOTINIT_0003: # else
	.word XT_PVARENA1
	.word XT_DOTO
	.word XT_PVARENA
PVARENADOTINIT_0004: # then
	.word XT_DOBRANCH,PVARENADOTINIT_0005
PVARENADOTINIT_0002: # else
	.word XT_PVARENA1
	.word XT_DOTO
	.word XT_PVARENA
	.word XT_2DROP
PVARENADOTINIT_0005: # then
	.word XT_DOBRANCH,PVARENADOTINIT_0006
PVARENADOTINIT_0001: # else
	.word XT_PVARENA2
	.word XT_FETCH_PVF
	.word XT_1PLUS
	.word XT_DOCONDBRANCH,PVARENADOTINIT_0007
	.word XT_PVARENA2
	.word XT_DOTO
	.word XT_PVARENA
	.word XT_DOBRANCH,PVARENADOTINIT_0008
PVARENADOTINIT_0007: # else
	.word XT_DOLITERAL
	.word 0x80000000
	.word XT_PVARENA1
	.word XT_STORE_PVF
	.word XT_ZERO
	.word XT_PVARENA1
	.word XT_CELLPLUS
	.word XT_STORE_PVF
	.word XT_PVARENA1
	.word XT_DOTO
	.word XT_PVARENA
PVARENADOTINIT_0008: # then
	.word XT_DROP
PVARENADOTINIT_0006: # then
	.word XT_EXIT
END PVARENADOTINIT

# ----------------------------------------------------------------------

COLON "pv.init", PVDOTINIT /* ( -- ) replay pvarena records, set pvp */
/*  The pvalues must be initialized with their default values first (like any values),
    then this will replay all the pvalue records, ending up with the latest persisted state. */
	.word XT_PVARENADOTINIT
	.word XT_PVARENA
	.word XT_CELLPLUS
	.word XT_CELLPLUS
PVDOTINIT_0001: # begin
	.word XT_DUP
	.word XT_FETCH_PVF
	.word XT_DUP
	.word XT_1PLUS
	.word XT_DOCONDBRANCH,PVDOTINIT_0002
	.word XT_SWAP
	.word XT_CELLPLUS
	.word XT_TUCK
	.word XT_FETCH_PVF
	.word XT_SWAP
	.word XT_STORE
	.word XT_CELLPLUS
	.word XT_DOBRANCH,PVDOTINIT_0001
PVDOTINIT_0002:
	.word XT_DROP
	.word XT_DOTO
	.word XT_PVP
	.word XT_EXIT
END PVDOTINIT

# ----------------------------------------------------------------------

COLON "pvarena.dormant", PVARENADOTDORMANT /* ( -- addr ) return address of the other arena */
	.word XT_PVARENA1
	.word XT_PVARENA
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,PVARENADOTDORMANT_0001
	.word XT_PVARENA2
	.word XT_DOBRANCH,PVARENADOTDORMANT_0002
PVARENADOTDORMANT_0001: # else
	.word XT_PVARENA1
PVARENADOTDORMANT_0002: # then
	.word XT_EXIT
END PVARENADOTDORMANT

# ----------------------------------------------------------------------

COLON "pvarena.erase", PVARENADOTERASE /* ( addr -- ) erase arena at addr from the end */
	.word XT_DUP
	.word XT_PVARENA_SIZE
	.word XT_PLUS
	.word XT_PVFLASH_SIZE
	.word XT_MINUS
PVARENADOTERASE_0001: # begin
	.word XT_2DUP
	.word XT_LESSEQUAL
	.word XT_DOCONDBRANCH,PVARENADOTERASE_0002
	.word XT_DUP
	.word XT_PVF_ERASE
	.word XT_PVFLASH_SIZE
	.word XT_MINUS
	.word XT_DOBRANCH,PVARENADOTERASE_0001
PVARENADOTERASE_0002:
	.word XT_2DROP
	.word XT_EXIT
END PVARENADOTERASE

# ----------------------------------------------------------------------

NONAME PVDOTWRITEWORD /* ( awp ffa - awp++ ) write pvalue record at awp if ffa is pvalue, advance awp */
/*  Used to prepare dormant arena for arena swap */
	.word XT_DUP
	.word XT_FETCH
    .word XT_FLAGDOTPVALUE
	.word XT_AND
	.word XT_DOCONDBRANCH,PVDOTWRITEWORD_0001
	.word XT_FFA2CFA
	.word XT_TO_BODY
	.word XT_FETCH
	.word XT_2DUP
	.word XT_SWAP
	.word XT_STORE_PVF
	.word XT_FETCH
	.word XT_SWAP
	.word XT_CELLPLUS
	.word XT_TUCK
	.word XT_STORE_PVF
	.word XT_CELLPLUS
	.word XT_DOBRANCH,PVDOTWRITEWORD_0002
PVDOTWRITEWORD_0001: # else
	.word XT_DROP
PVDOTWRITEWORD_0002: # then
	.word XT_TRUE
	.word XT_EXIT
END PVDOTWRITEWORD

# ----------------------------------------------------------------------

COLON "pvarena.swap", PVARENADOTSWAP /* ( -- ) write fresh pvalues into the dormant arena and swap arenas */
/*  second cell of the arena record is written first to mark it dirty
    if arena is dirty it is erased completely first (erase the first block last)
    first cell of arena record is written last, with ID +1 of the active arena,
    this marks the arena complete and active. */
	.word XT_PVARENADOTDORMANT
	.word XT_DUP
	.word XT_CELLPLUS
	.word XT_DUP
	.word XT_FETCH_PVF
	.word XT_1PLUS
	.word XT_NOTZEROEQUAL
	.word XT_DOCONDBRANCH,PVARENADOTSWAP_0001
	.word XT_DUP
	.word XT_PVARENADOTERASE
PVARENADOTSWAP_0001: # then
	.word XT_DUP
	.word XT_ZERO
	.word XT_SWAP
	.word XT_STORE_PVF
	.word XT_CELLPLUS
	.word XT_DOLITERAL
	.word XT_PVDOTWRITEWORD
	.word XT_FORTH_WORDLIST
	.word XT_TRAVERSEWORDLIST
	.word XT_SWAP
	.word XT_DUP
	.word XT_PVARENA
	.word XT_FETCH_PVF
	.word XT_1PLUS
	.word XT_SWAP
	.word XT_STORE_PVF
	.word XT_PVARENA
	.word XT_SWAP
	.word XT_DOTO
	.word XT_PVARENA
	.word XT_SWAP
	.word XT_DOTO
	.word XT_PVP
	.word XT_PVARENADOTERASE
	.word XT_EXIT
END PVARENADOTSWAP
