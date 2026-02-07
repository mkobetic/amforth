/* 
\ transpiling pval.f on 2026/02/06 18:38:12

\ Main goals of the pvalue subsystem are:
\ * simplicity over more optimal in some respect but more complex solution
\ * robustness - should be able to recover in face of reset without losing persisted state

\ Updating a pvalue means writing a new pvalue record in the current pvarena,
\ and then updating the corresponding RAM cell with the same value.
: pv.store ( x xt -- ) \ update pvalue identified by xt to value x
    \ translate xt to the value RAM address
    >body @ (x addr)
    \ if pvarena.size is 0 do just the RAM update, skip the rest
    pvarena.size dup 0= if ! exit then
    \ check that there is room in the current arena, compact and swap arenas otherwise
    pvarena + pvp <= if pvarena.swap then
    \ write pvalue RAM address as the record ID
    dup pvp !pvf \ store addr at pvp
    over pvp cell+ tuck \ ( x addr pvp+ x pvp+ )
    !pvf \ store x at pvp+
    cell+ to pvp \ update pvp to pvp++
    ! \ update ram
;

: vaddr ( "name" -- addr ) \ RAM address of value "name"
    ' >body @ ;

\ Arena state is stored in the first record of the arena.
\ First cell is a counter with MSB set (so that it doesn't match any real RAM address).
\ Second cell is either -1 or 0. Erased dormant arena has both cells set to -1.
\ Current arena is the one with higher ID that is not -1.
: pvarena.init ( -- ) \ set pvarena to whichever arena should be current
    pvarena1 @pvf dup 1+ if \ is arena1 dormant? (ID = -1)
        pvarena2 @pvf dup 1+ if \ is arena2 dormant?
            \ (a1id a2id) higher ID wins
            < if pvarena2 to pvarena
            else pvarena1 to pvarena
            then
        else \ arena2 is dormant ( a1id -1 )
            pvarena1 to pvarena
            2drop \ unused arena IDs
        then
    else \ arena1 is dormant ( -1 )
        pvarena2 @pvf 1+ if \ is arena2 dormant?
            pvarena2 to pvarena
        else \ arena2 is dormant
            \ both arenas are blank, initialize arena1 and use it.
            $80000000 pvarena1 !pvf
            0 pvarena1 cell+ !pvf
            pvarena1 to pvarena
        then
        drop \ unused arena1 ID
    then ;

\ TODO: This should be called from warm after the normal value init runs.
\ The pvalues must be initialized with their default values first (like any values),
\ then this will replay all the pvalue records, ending up with the latest persisted state.
: pv.init ( -- ) \ replay pvarena records, set pvp
    \ if pvarena.size is 0 do nothing
    pvarena.size 0= if exit then
    pvarena.init \ initialize pvarena
    pvarena cell+ cell+ \ skip the arena record
    begin
    dup @pvf dup 1+ while \ if record id is not all 1 bits, i.e. -1
        \ ( pvp pv-ram )
        swap cell+ tuck @pvf \ ( pvp+ pv-ram [pvp+] )
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
\ erase the first block last in case the erase operation is interrupted
    dup pvarena.size + pvflash.page -
    begin 2dup <= while
        dup pvflash.erase
        pvflash.page -
    repeat
    2drop
;

\ helper for pv.do that follows
:noname ( xt ffa -- xt f ) 
    dup @ flag.pvalue and if
        \ need to stow the xt away while executing it
        \ so that the word can work with the underlying stack
        \ afterwards restore the xt to the stack and return the result on top
        ffa2cfa swap dup >r execute r> swap
    else drop true then
;

 \ this definition must follow the noname above, assumes its xt on the stack (see literal)
: pv.do ( xt -- ) \ run xt ( pv-xt -- f ) for every pvalue in forth-wordlist
    literal forth-wordlist traverse-wordlist
    drop \ drop the xt at the end
;


\ used to prepare dormant arena for arena swap (this should be noname)
: pv.write ( awp ffa - awp++ f ) \ write pvalue record at awp, advance awp
    >body @ \ (awp pv-ram)
    2dup swap !pvf @ \ write record ID (awp [pv-ram] )
    swap cell+ tuck !pvf \ write the value (awp+)
    cell+ \ (awp++)
    true
;

\ second cell of the arena record is written first to mark it dirty
\ if arena is dirty it is erased completely first (erase the first block last in case the erase operation is interrupted)
\ first cell of arena record is written last, with ID +1 of the active arena,
\ this marks the arena complete and active.
\ it should be always possible to rerun a swap if it fails to complete for whatever reason (e.g. reset)
\ it can also be run explicitly, doesn't have to be invoked automatically by pv.store
: pvarena.swap ( -- ) \ write fresh pvalues into the dormant arena and swap arenas
    pvarena.dormant
    \ check if it needs to be erased
    dup cell+ dup @pvf 1+ 0<> if dup pvarena.erase then
    \ write dirty mark ( arena arena+ )
    dup 0 swap !pvf cell+ \ ( arena arena++ )
    \ write fresh record for each persistent value in forth-wordlist
    ['] pv.write pv.do
    swap \ swap the arena pointers ( awp arena )
    \ write arena ID (this must happen last)
    dup pvarena @pvf 1+ swap !pvf
    \ swap arenas ( awp arena )
    pvarena swap ( awp old-arena new-arena )
    to pvarena swap \ set pvarena
    to pvp \ set pvp
    pvarena.erase \ erase old arena
;

: noname ( xt ffa -- xt f ) \ helper for pv.do
    dup @ flag.pvalue and if
        ffa2cfa over execute
    else drop true then
;
: pv.do ( xt -- ) run xt ( pv-xt -- f ) for every pvalue in forth-wordlist
    literal , forth-wordlist traverse-wordlist
;

*/

/* following deferred words are data flash primitives that need to be implemented by the MCU */

DEFER "!pvf", STORE_PVF, XT_STORE /* (x addr -- ) store x at addr in the PV flash */
END STORE_PVF

DEFER "@pvf", FETCH_PVF, XT_FETCH /* (addr -- x) load cell at addr in the PV flash */
END FETCH_PVF

DEFER "pvflash.erase", PVF_ERASE, XT_FAUXERASE /* ( addr -- ) erase PV flash page at addr */
END FETCH_PVF

NONAME FAUXERASE /* :noname pvflash.page $FF fill ; */
    .word XT_PVFLASH_PAGE, XT_PVFLASH_FF, XT_FILL, XT_EXIT
END FAUXERASE

/* this is just a hack to avoid XT_DOLITERAL, 0xFF in FAUXERASE
 because it's insanely complicated to step through */
CONSTANT "pvflash.ff", PVFLASH_FF, 0xFF /* value of an erased byte in flash */
END PVFLASH_FF

/* pvalue memory constants */

CONSTANT "pvarena1", PVARENA1, pvarena1_lower /* address of pvalue arena 1  */
END PVARENA1

CONSTANT "pvarena2", PVARENA2, pvarena2_lower /* address of pvalue arena 2  */
END PVARENA2

CONSTANT "pvarena.size", PVARENA_SIZE, pvarena.size /* size of pvalue arena (multiple of flash page size) */
END PVARENA_SIZE

CONSTANT "pvflash.page", PVFLASH_PAGE, pvflash.page /* size of PV flash page */
END PVFLASH_PAGE

CONSTANT "pvflash.size", PVFLASH_SIZE, pvflash.size /* total size of PV flash */
END PVFLASH_SIZE


/* pvalue runtime values, must be initialized by pv.init */

VALUE "pvp", PVP, 0 /* ( -- addr ) address of the next free cell in active arena */
END PVP

VALUE "pvarena", PVARENA, 0 /* ( -- addr ) start address of the active arena */
END PVARENA

/* test pvalues */
PVALUE "pv1", PV1, 42
END PV1
PVALUE "pv2", PV2, 42
END PV2
PVALUE "pv3", PV3, 42
END PV3


# ----------------------------------------------------------------------

COLON "pv.store", PV_STORE /* ( x xt -- ) update pvalue identified by xt to value x */
/*  Updating a pvalue means writing a new pvalue record in the current pvarena,
    and then updating the corresponding RAM cell with the same value.
    If current arena is full run pvarena.swap first. */
    /* convert XT to RAM address */
    .word XT_TO_BODY, XT_FETCH
    /* if pvarena.size is 0 do just the RAM update, skip the rest */
    .word XT_PVARENA_SIZE, XT_DUP, XT_ZEROEQUAL, XT_DOCONDBRANCH, 1f
        .word XT_STORE, XT_EXIT
1:
    /*  check that there is room in the current arena,
        compact and swap arenas otherwise */
	.word XT_PVARENA
	.word XT_PLUS
	.word XT_PVP
	.word XT_LESSEQUAL
	.word XT_DOCONDBRANCH, 2f
	    .word XT_PVARENA_SWAP
 2: # then
    /* (x addr) */
    /* write pvalue RAM address as the record ID */
	.word XT_DUP
	.word XT_PVP
	.word XT_STORE_PVF
	.word XT_OVER
	.word XT_PVP
	.word XT_CELLPLUS
	.word XT_TUCK
    /* ( x addr pvp+ x pvp+ ) */
    /* write x next */
	.word XT_STORE_PVF
    /* update PVP */
	.word XT_CELLPLUS
	.word XT_DOTO
	.word XT_PVP
    /* update RAM */
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

COLON "pvarena.init", PVARENA_INIT /* ( -- ) set pvarena to whichever arena should be current */
/*  Arena state is stored in the first record of the arena.
    First cell is a counter with MSB set (so that it doesn't match any real RAM address).
    Second cell is either -1 or 0. Erased dormant arena has both cells set to -1.
    Current arena is the one with higher ID that is not -1. */
    /* if pvarena.size is 0 do nothing, just exit */
    .word XT_PVARENA_SIZE, XT_ZEROEQUAL, XT_DOCONDBRANCH, 1f
        .word XT_EXIT
1:
	.word XT_PVARENA1
	.word XT_FETCH_PVF
	.word XT_DUP
	.word XT_1PLUS
	.word XT_DOCONDBRANCH,PVARENA_INIT_0001
	.word XT_PVARENA2
	.word XT_FETCH_PVF
	.word XT_DUP
	.word XT_1PLUS
	.word XT_DOCONDBRANCH,PVARENA_INIT_0002
	.word XT_LESS
	.word XT_DOCONDBRANCH,PVARENA_INIT_0003
	.word XT_PVARENA2
	.word XT_DOTO
	.word XT_PVARENA
	.word XT_DOBRANCH,PVARENA_INIT_0004
PVARENA_INIT_0003: # else
	.word XT_PVARENA1
	.word XT_DOTO
	.word XT_PVARENA
PVARENA_INIT_0004: # then
	.word XT_DOBRANCH,PVARENA_INIT_0005
PVARENA_INIT_0002: # else
	.word XT_PVARENA1
	.word XT_DOTO
	.word XT_PVARENA
	.word XT_2DROP
PVARENA_INIT_0005: # then
	.word XT_DOBRANCH,PVARENA_INIT_0006
PVARENA_INIT_0001: /* else \ arena1 is dormant */
	.word XT_PVARENA2
	.word XT_FETCH_PVF
	.word XT_1PLUS
	.word XT_DOCONDBRANCH,PVARENA_INIT_0007
	.word XT_PVARENA2
	.word XT_DOTO
	.word XT_PVARENA
	.word XT_DOBRANCH,PVARENA_INIT_0008
PVARENA_INIT_0007: # else
    /* both arenas are blank, initialize arena1 and use it. */
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
PVARENA_INIT_0008: # then
	.word XT_DROP
PVARENA_INIT_0006: # then
	.word XT_EXIT
END PVARENA_INIT

# ----------------------------------------------------------------------

COLON "pv.init", PV_INIT /* ( -- ) replay pvarena records, set pvp */
/*  The pvalues must be initialized with their default values first (like any values),
    then this will replay all the pvalue records, ending up with the latest persisted state. */
	.word XT_PVARENA_INIT
	.word XT_PVARENA
	.word XT_CELLPLUS
	.word XT_CELLPLUS
PV_INIT_0001: # begin
	.word XT_DUP
	.word XT_FETCH_PVF
	.word XT_DUP
	.word XT_1PLUS
	.word XT_DOCONDBRANCH,PV_INIT_0002
	.word XT_SWAP
	.word XT_CELLPLUS
	.word XT_TUCK
	.word XT_FETCH_PVF
	.word XT_SWAP
	.word XT_STORE
	.word XT_CELLPLUS
	.word XT_DOBRANCH,PV_INIT_0001
PV_INIT_0002:
	.word XT_DROP
	.word XT_DOTO
	.word XT_PVP
	.word XT_EXIT
END PV_INIT

# ----------------------------------------------------------------------

COLON "pvarena.dormant", PVARENA_DORMANT /* ( -- addr ) start address of the dormant arena */
	.word XT_PVARENA1
	.word XT_PVARENA
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,PVARENA_DORMANT_0001
	.word XT_PVARENA2
	.word XT_DOBRANCH,PVARENA_DORMANT_0002
PVARENA_DORMANT_0001: # else
	.word XT_PVARENA1
PVARENA_DORMANT_0002: # then
	.word XT_EXIT
END PVARENA_DORMANT

# ----------------------------------------------------------------------

COLON "pvarena.erase", PVARENA_ERASE /* ( addr -- ) erase arena at addr */
/* erase the first block last in case the erase operation is interrupted */
	.word XT_DUP
	.word XT_PVARENA_SIZE
	.word XT_PLUS
	.word XT_PVFLASH_PAGE
	.word XT_MINUS
PVARENA_ERASE_0001: # begin
	.word XT_2DUP
	.word XT_LESSEQUAL
	.word XT_DOCONDBRANCH,PVARENA_ERASE_0002
	.word XT_DUP
	.word XT_PVF_ERASE
	.word XT_PVFLASH_PAGE
	.word XT_MINUS
	.word XT_DOBRANCH,PVARENA_ERASE_0001
PVARENA_ERASE_0002:
	.word XT_2DROP
	.word XT_EXIT
END PVARENA_ERASE

# ----------------------------------------------------------------------

NONAME PV_WRITE /* ( awp ffa - awp++ f ) write pvalue record at awp, advance awp */
/*  Used to prepare dormant arena for arena swap */
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
	.word XT_TRUE
	.word XT_EXIT
END PV_WRITE

# ----------------------------------------------------------------------

COLON "pvarena.swap", PVARENA_SWAP /* ( -- ) write fresh pvalues into the dormant arena and swap arenas */
/*  Second cell of the arena record is written first to mark it dirty.
    If arena is dirty it is erased completely first (erase the first block last in case the erase is interrupted.)
    First cell of arena record is written last, with ID +1 of the active arena,
    this marks the arena complete and active.
    It should be always possible to rerun a swap if it fails to complete for whatever reason (e.g. reset)
    It can also be run explicitly, doesn't have to be invoked automatically by pv.store. */
	.word XT_PVARENA_DORMANT
	.word XT_DUP
	.word XT_CELLPLUS
	.word XT_DUP
	.word XT_FETCH_PVF
	.word XT_1PLUS
	.word XT_NOTZEROEQUAL
	.word XT_DOCONDBRANCH,PVARENA_SWAP_0001
	.word XT_DUP
	.word XT_PVARENA_ERASE
PVARENA_SWAP_0001: # then
	.word XT_DUP
	.word XT_ZERO
	.word XT_SWAP
	.word XT_STORE_PVF
	.word XT_CELLPLUS
	.word XT_DOLITERAL
	.word XT_PV_WRITE
	.word XT_PV_DO
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
	.word XT_PVARENA_ERASE
	.word XT_EXIT
END PVARENA_SWAP

NONAME PV_DO1 /* ( xt ffa -- xt f ) helper for pv.do */
/*  :noname ( xt ffa -- xt f ) \ helper for pv.do
    dup @ flag.pvalue and if
        \ need to stow the xt away while executing it
        \ so that it can work with the underlying stack,
        \ afterwards restore the xt to the stack and return the boolean on top
        ffa2cfa swap dup >r execute r> swap
    else drop true then
; */
	.word XT_DUP
	.word XT_FETCH
    .word XT_FLAGDOTPVALUE
	.word XT_AND
	.word XT_DOCONDBRANCH, 1f
	.word XT_FFA2CFA
	.word XT_SWAP, XT_DUP, XT_TO_R
	.word XT_EXECUTE
    .word XT_R_FROM, XT_SWAP
	.word XT_DOBRANCH, 2f
1: # else
	.word XT_DROP
	.word XT_TRUE
2: # then
	.word XT_EXIT
END PV_DO1

COLON "pv.do", PV_DO /* ( xt -- ) run xt ( pv-xt -- f ) for every pvalue in forth-wordlist */
/*  \ this definition must follow the noname above, assumes its xt on the stack.
    : pv.do ( xt -- ) \ run xt ( pv-xt -- f ) for every pvalue in forth-wordlist
    literal forth-wordlist traverse-wordlist
    drop \ drop the xt at the end
; */
    .word XT_DOLITERAL, XT_PV_DO1
    .word XT_FORTH_WORDLIST
	.word XT_TRAVERSEWORDLIST
    .word XT_DROP
    .word XT_EXIT
END PV_DO
