# SPDX-License-Identifier: GPL-3.0-only
# transpiling x.f on 2024/03/28 23:58:28
# : ffa>xt ( ffa -- xt )
#     ffa>nfa count + aligned
# ;
# 
# : (ram.xt?) ( ret xt ffa -- ret xt f )
#     ffa>nfa nfa>xt over = if
#         swap 1+ swap
#         false
#     else
#         true
#     then
# ;
# 
# : ram.xt? ( xt -- f )
#     0 swap ['] (ram.xt?) ram-wordlist traverse-wordlist drop
# ;
# 
# 
# variable ram.p \ pointer into ram.buf
# variable start.flash.p
# 
# variable save.ip
# variable save.lfa
# variable save.done?
# 
# : save.ip++ cell save.ip +! ;
# 
# 
# : save.cache++! ( -- )
#     cell ram.p +!
#     \ s" cache " type ram.p @ u. ram.p @ $ff and u. cr
#     ram.p @ $ff and 0= if \ rolled flash 256 byte page
#         cr [char] * emit cr  \ signals a cache save
#         ram>flash
#         flash.p $ffffff00 and $100 + ['] flash.p cell+ @ !
#         0 ram.p !
#         flash>ram
#         cr [char] + emit cr  \ signals a cache save
#     then
# ;
# 
# 
# : save.lfa? save.lfa @ = ;
# : save.ffa? save.lfa @ lfa>ffa = ;
# : save.nfa? save.lfa @ lfa>ffa ffa>nfa = ;
# 
# 
# : save.do.lfa ( -- ) \# OK
#     forth-wordlist flash.p $ff and ram.buf + ! \ attach wordlist
#     save.cache++! save.ip++
# ;
# 
# : save.line ( -- ) \# OK
#     save.ip @ @ ram.buf ram.p @ + ! save.cache++!
# ;
# 
# : save.line++ ( -- ) \# OK
#     save.line save.ip++
# ;
# 
# : save.do.colon \ #OK
#     save.line++
# ;
# 
# : save.do.ffa \# OK
#     save.line++
# ;
# 
# : save.do.nfa
#     save.line
# 
#     save.ip @ c@ 1+ aligned 4 / 1-
#     \ dup s" INDEX " type u. cr
# 
#     save.ip++
# 
#     0 ?do save.line++ loop
# ;
# 
# : save.do.lit \# OK
#     save.line++
#     save.line++
# ;
# 
# : save.do.bra \# ok
#     save.line++
#     save.ip @ @ save.ip @ - flash.p $FFFFFF00 and + ram.p @ +
#     ram.buf ram.p @ + ! save.cache++! save.ip++
# ;
# 
# : save.unwind ( -- )
#     start.flash.p @ ['] flash.p cell+ @ !
#     rom>ram
#     flash.p ram.buf 2 cells + @ - ram.buf 3 cells + !
#     ram>rom
# ;
# 
# \ get string from nfa via xt (could be a RAM or FLASH xt)
# \ then see name exists in forth-wordlist and if so use xt
# 
# : save.do.xlit \#
#     save.line++
#     save.ip @ @ xt>string forth-wordlist search-wordlist if
#         ram.buf ram.p @ + ! save.cache++!
#     else
#         || s" RAM word not in FLASH" type cr
#         s" FAIL " type save.ip @ @ xt>string type s" not in FLASH" type cr
#         save.unwind abort
#     then
#     save.ip++
# ;
# 
# : save.do.slit
# 
#     save.line++
# 
#     save.ip @ c@ 1+ aligned 4 / 1-
#     \ dup s" INDEX " type u. cr
# 
#     save.line++
#     \ save.ip++
# 
#     0 ?do save.line++ loop
# 
# ;
# 
# : save.do.exit \# OK
#     \ s" EXIT" type cr
#     save.ip @ @ ram.buf ram.p @ + ! \ write to buffer
#     ram>flash                       \ write buffer to flash
#     true save.done? !
#     save.ip++
# ;
# 
# : save.any? drop true ;
# 
# 
# : save.do.xt ( -- )
# 
#     save.ip @ @ xt>string forth-wordlist search-wordlist if
#         \ save.ip @ @ xt>string type cr
#         ram.buf ram.p @ + ! save.cache++!
#     else
#         || s" RAM word not in FLASH" type cr
#         s" FAIL " type save.ip @ @ xt>string type s" not in FLASH" type cr
#         save.unwind abort
#     then
#     save.ip++
# ;
# 
# \ etc.
# 
# : save.rom
# 
#     \ update the forth-wordlist
#     start.flash.p @ cell+ ['] forth-wordlist cell+ @ !
# 
#     \ how many bytes to add to flash.p
#     save.ip @ save.lfa @ - start.flash.p @ + >flash.p
# 
#     \ save the new differentials to the "rom"
#     rom>ram
#     \ forth-wordlist hex. start.flash.p @ cell+ hex. ram.buf @ hex. flash.low @ hex. cr
#     forth-wordlist    ram.buf @ - ram.buf cell+ !
#     flash.p ram.buf 2 cells + @ - ram.buf 3 cells + !
#     ram     ram.buf 4 cells + @ - ram.buf 5 cells + !
#     rom     ram.buf 6 cells + @ - ram.buf 7 cells + !
#     ram>rom
# 
# ;
# 
# 
# : save.colon  \# ( ffa -- ) SAVE: save a colon word (subword in save)
# 
#     ffa>lfa dup save.ip ! save.lfa ! false save.done? !
#     flash>ram flash.p $ff and ram.p ! flash.p start.flash.p !
# 
#     s" Saving >> " type save.lfa @ lfa>ffa ffa>xt xt>string type
#     s"  << " type
#     begin
#         save.ip @ match
#             ['] save.lfa?  act save.do.lfa end
#             ['] save.ffa?  act save.do.ffa end
#             ['] save.nfa?  act save.do.nfa end
#             ['] colon?     act save.do.colon end
#             ['] literal?   act save.do.lit end
#             ['] xliteral?  act save.do.xlit end
#             ['] sliteral?  act save.do.slit end
#             ['] anybranch? act save.do.bra end
#             ['] exit?      act save.do.exit end
#             ['] save.any?  act save.do.xt end
#         endmatch
#     save.done? @ until
# 
#     save.rom
#     s" SUCCESS" type cr
# ;
# 
# 
# 
# : save.var ( ffa -- )
#     ffa>lfa dup save.ip ! save.lfa ! false save.done? !
#     flash>ram flash.p $ff and ram.p ! flash.p start.flash.p !
# 
#     s" Saving >> " type save.lfa @ lfa>ffa ffa>xt xt>string type
#     s"  << " type
# 
#     save.do.lfa
#     save.do.ffa
#     save.do.nfa
#     save.line++
#     save.line++
# 
#     ram>flash save.rom
# 
#     s" SUCCESS" type cr
# 
# ;
# 
# : save.how
#     >r
#     r@ ffa2cfa variable? if r@ save.var   rdrop exit then
#     r@ ffa2cfa colon?    if r@ save.colon rdrop exit then
# ;
# 
# : save.inner ( ffa -- f )
#     dup ffa>lfa @ 0= if
#         ,
#         \ dup ,
#         \ dup hex. ffa>xt xt>string type cr
#         false
#     else
#         ,
#         \ dup ,
#         \ dup hex. ffa>xt xt>string type cr
#         true
#    then
# ;
# 
# : save.list ( -- )
#     here >r               \ put start on return stack
#     ['] save.inner ram-wordlist traverse-wordlist 2drop
#     here begin            \ end+cell....start
#         cell- dup         \ a a --
#         dup @ save.how    \ a a --
#     r@ = until            \   a --
#     drop rdrop
# ;
# 
# : save \# ( "name" -- ) SAVE: save "name" in RAM or all in RAM to FLASH
#     parse-name dup if
#         find-xt if
#             dup ram.xt? if
#                 xt>ffa save.how
#             else
#                 drop
#                 s" name not found in RAM dictionary" type cr
#             then
#         else
#             s" name not found in ANY dictionary" type cr
#         then
#     else
#         ram-wordlist 0= if
#             s" RAM dictionary empty" type cr
#         else
#             s" Saving entire RAM dictionary..." type cr
#             save.list
#         then
#     then
# ;
# 
# 
# 

# ----------------------------------------------------------------------
COLON "ffa>xt", FFAGTXT 
	.word XT_FFA2NFA
	.word XT_COUNT
	.word XT_PLUS
	.word XT_ALIGNED
	.word XT_EXIT
# ----------------------------------------------------------------------
COLON "(ram.xt?)", LPARENRAMDOTXTQRPAREN 
	.word XT_FFA2NFA
	.word XT_NFA2XT
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,LPARENRAMDOTXTQRPAREN_0001 # if
	.word XT_SWAP
	.word XT_1PLUS
	.word XT_SWAP
	.word XT_FALSE
	.word XT_DOBRANCH,LPARENRAMDOTXTQRPAREN_0002
LPARENRAMDOTXTQRPAREN_0001: # else
	.word XT_TRUE
LPARENRAMDOTXTQRPAREN_0002: # then
	.word XT_EXIT
# ----------------------------------------------------------------------
COLON "ram.xt?", RAMDOTXTQ 
	.word XT_ZERO
	.word XT_SWAP
	.word XT_DOLITERAL
	.word XT_LPARENRAMDOTXTQRPAREN
	.word XT_RAM_WORDLIST
	.word XT_TRAVERSEWORDLIST
	.word XT_DROP
	.word XT_EXIT
# ----------------------------------------------------------------------
VARIABLE "ram.p",RAMDOTP
VARIABLE "start.flash.p",STARTDOTFLASHDOTP
VARIABLE "save.ip",SAVEDOTIP
VARIABLE "save.lfa",SAVEDOTLFA
VARIABLE "save.done?",SAVEDOTDONEQ
# ----------------------------------------------------------------------
COLON "save.ip++", SAVEDOTIPPLUSPLUS 
	.word XT_CELL
	.word XT_SAVEDOTIP
	.word XT_PLUSSTORE
	.word XT_EXIT
# ----------------------------------------------------------------------
COLON "save.cache++!", SAVEDOTCACHEPLUSPLUSBANG 
	.word XT_CELL
	.word XT_RAMDOTP
	.word XT_PLUSSTORE
	.word XT_RAMDOTP
	.word XT_FETCH
	.word XT_DOLITERAL
	.word 0xff
	.word XT_AND
	.word XT_ZEROEQUAL
	.word XT_DOCONDBRANCH,SAVEDOTCACHEPLUSPLUSBANG_0001 # if
	.word XT_CR
	.word XT_DOLITERAL # [char]
	.word 42 # *
	.word XT_EMIT
	.word XT_CR
	.word XT_RAM_TO_FLASH
	.word XT_FLASH_P
	.word XT_DOLITERAL
	.word 0xffffff00
	.word XT_AND
	.word XT_DOLITERAL
	.word 0x100
	.word XT_PLUS
	.word XT_DOLITERAL
	.word XT_FLASH_P
	.word XT_CELLPLUS
	.word XT_FETCH
	.word XT_STORE
	.word XT_ZERO
	.word XT_RAMDOTP
	.word XT_STORE
	.word XT_FLASH_TO_RAM
	.word XT_CR
	.word XT_DOLITERAL # [char]
	.word 43 # +
	.word XT_EMIT
	.word XT_CR
SAVEDOTCACHEPLUSPLUSBANG_0001: # then
	.word XT_EXIT
# ----------------------------------------------------------------------
COLON "save.lfa?", SAVEDOTLFAQ 
	.word XT_SAVEDOTLFA
	.word XT_FETCH
	.word XT_EQUAL
	.word XT_EXIT
# ----------------------------------------------------------------------
COLON "save.ffa?", SAVEDOTFFAQ 
	.word XT_SAVEDOTLFA
	.word XT_FETCH
	.word XT_LFA2FFA
	.word XT_EQUAL
	.word XT_EXIT
# ----------------------------------------------------------------------
COLON "save.nfa?", SAVEDOTNFAQ 
	.word XT_SAVEDOTLFA
	.word XT_FETCH
	.word XT_LFA2FFA
	.word XT_FFA2NFA
	.word XT_EQUAL
	.word XT_EXIT
# ----------------------------------------------------------------------
COLON "save.do.lfa", SAVEDOTDODOTLFA # OK 
	.word XT_FORTH_WORDLIST
	.word XT_FLASH_P
	.word XT_DOLITERAL
	.word 0xff
	.word XT_AND
	.word XT_RAM_BUF
	.word XT_PLUS
	.word XT_STORE
	.word XT_SAVEDOTCACHEPLUSPLUSBANG
	.word XT_SAVEDOTIPPLUSPLUS
	.word XT_EXIT
# ----------------------------------------------------------------------
COLON "save.line", SAVEDOTLINE # OK
	.word XT_SAVEDOTIP
	.word XT_FETCH
	.word XT_FETCH
	.word XT_RAM_BUF
	.word XT_RAMDOTP
	.word XT_FETCH
	.word XT_PLUS
	.word XT_STORE
	.word XT_SAVEDOTCACHEPLUSPLUSBANG
	.word XT_EXIT
# ----------------------------------------------------------------------
COLON "save.line++", SAVEDOTLINEPLUSPLUS # OK 
	.word XT_SAVEDOTLINE
	.word XT_SAVEDOTIPPLUSPLUS
	.word XT_EXIT
# ----------------------------------------------------------------------
COLON "save.do.colon", SAVEDOTDODOTCOLON 
	.word XT_SAVEDOTLINEPLUSPLUS
	.word XT_EXIT
# ----------------------------------------------------------------------
COLON "save.do.ffa", SAVEDOTDODOTFFA # OK 
	.word XT_SAVEDOTLINEPLUSPLUS
	.word XT_EXIT
# ----------------------------------------------------------------------
COLON "save.do.nfa", SAVEDOTDODOTNFA 
	.word XT_SAVEDOTLINE
	.word XT_SAVEDOTIP
	.word XT_FETCH
	.word XT_CFETCH
	.word XT_1PLUS
	.word XT_ALIGNED
	.word XT_FOUR
	.word XT_SLASH
	.word XT_1MINUS
	.word XT_SAVEDOTIPPLUSPLUS
	.word XT_ZERO
	.word XT_QDOCHECK, XT_DOCONDBRANCH,SAVEDOTDODOTNFA_0001 # ?do
	.word XT_DODO
SAVEDOTDODOTNFA_0002: # do
	.word XT_SAVEDOTLINEPLUSPLUS
	.word XT_DOLOOP,SAVEDOTDODOTNFA_0002 # loop
SAVEDOTDODOTNFA_0001: # (for ?do IF required) 
	.word XT_EXIT
# ----------------------------------------------------------------------
COLON "save.do.lit", SAVEDOTDODOTLIT # OK 
	.word XT_SAVEDOTLINEPLUSPLUS
	.word XT_SAVEDOTLINEPLUSPLUS
	.word XT_EXIT
# ----------------------------------------------------------------------
COLON "save.do.bra", SAVEDOTDODOTBRA # ok
	.word XT_SAVEDOTLINEPLUSPLUS
	.word XT_SAVEDOTIP
	.word XT_FETCH
	.word XT_FETCH
	.word XT_SAVEDOTIP
	.word XT_FETCH
	.word XT_MINUS
	.word XT_FLASH_P
	.word XT_DOLITERAL
	.word 0xffffff00
	.word XT_AND
	.word XT_PLUS
	.word XT_RAMDOTP
	.word XT_FETCH
	.word XT_PLUS
	.word XT_RAM_BUF
	.word XT_RAMDOTP
	.word XT_FETCH
	.word XT_PLUS
	.word XT_STORE
	.word XT_SAVEDOTCACHEPLUSPLUSBANG
	.word XT_SAVEDOTIPPLUSPLUS
	.word XT_EXIT
# ----------------------------------------------------------------------
COLON "save.unwind", SAVEDOTUNWIND 
	.word XT_STARTDOTFLASHDOTP
	.word XT_FETCH
	.word XT_DOLITERAL
	.word XT_FLASH_P
	.word XT_CELLPLUS
	.word XT_FETCH
	.word XT_STORE
	.word XT_ROM_TO_RAM
	.word XT_FLASH_P
	.word XT_RAM_BUF
	.word XT_TWO
	.word XT_CELLS
	.word XT_PLUS
	.word XT_FETCH
	.word XT_MINUS
	.word XT_RAM_BUF
	.word XT_DOLITERAL
	.word 3
	.word XT_CELLS
	.word XT_PLUS
	.word XT_STORE
	.word XT_RAM_TO_ROM
	.word XT_EXIT
# ----------------------------------------------------------------------
COLON "save.do.xlit", SAVEDOTDODOTXLIT # 
	.word XT_SAVEDOTLINEPLUSPLUS
	.word XT_SAVEDOTIP
	.word XT_FETCH
	.word XT_FETCH
	.word XT_XT2STRING
	.word XT_FORTH_WORDLIST
	.word XT_SEARCH_WORDLIST
	.word XT_DOCONDBRANCH,SAVEDOTDODOTXLIT_0001 # if
	.word XT_RAM_BUF
	.word XT_RAMDOTP
	.word XT_FETCH
	.word XT_PLUS
	.word XT_STORE
	.word XT_SAVEDOTCACHEPLUSPLUSBANG
	.word XT_DOBRANCH,SAVEDOTDODOTXLIT_0002
SAVEDOTDODOTXLIT_0001: # else
	STRING "FAIL "
	.word XT_TYPE
	.word XT_SAVEDOTIP
	.word XT_FETCH
	.word XT_FETCH
	.word XT_XT2STRING
	.word XT_TYPE
	STRING "not in FLASH"
	.word XT_TYPE
	.word XT_CR
	.word XT_SAVEDOTUNWIND
	.word XT_ABORT
SAVEDOTDODOTXLIT_0002: # then
	.word XT_SAVEDOTIPPLUSPLUS
	.word XT_EXIT
# ----------------------------------------------------------------------
COLON "save.do.slit", SAVEDOTDODOTSLIT 
	.word XT_SAVEDOTLINEPLUSPLUS
	.word XT_SAVEDOTIP
	.word XT_FETCH
	.word XT_CFETCH
	.word XT_1PLUS
	.word XT_ALIGNED
	.word XT_FOUR
	.word XT_SLASH
	.word XT_1MINUS
	.word XT_SAVEDOTLINEPLUSPLUS
	.word XT_ZERO
	.word XT_QDOCHECK, XT_DOCONDBRANCH,SAVEDOTDODOTSLIT_0001 # ?do
	.word XT_DODO
SAVEDOTDODOTSLIT_0002: # do
	.word XT_SAVEDOTLINEPLUSPLUS
	.word XT_DOLOOP,SAVEDOTDODOTSLIT_0002 # loop
SAVEDOTDODOTSLIT_0001: # (for ?do IF required) 
	.word XT_EXIT
# ----------------------------------------------------------------------
COLON "save.do.exit", SAVEDOTDODOTEXIT # OK
	.word XT_SAVEDOTIP
	.word XT_FETCH
	.word XT_FETCH
	.word XT_RAM_BUF
	.word XT_RAMDOTP
	.word XT_FETCH
	.word XT_PLUS
	.word XT_STORE
	.word XT_RAM_TO_FLASH
	.word XT_TRUE
	.word XT_SAVEDOTDONEQ
	.word XT_STORE
	.word XT_SAVEDOTIPPLUSPLUS
	.word XT_EXIT
# ----------------------------------------------------------------------
COLON "save.any?", SAVEDOTANYQ 
	.word XT_DROP
	.word XT_TRUE
	.word XT_EXIT
# ----------------------------------------------------------------------
COLON "save.do.xt", SAVEDOTDODOTXT 
	.word XT_SAVEDOTIP
	.word XT_FETCH
	.word XT_FETCH
	.word XT_XT2STRING
	.word XT_FORTH_WORDLIST
	.word XT_SEARCH_WORDLIST
	.word XT_DOCONDBRANCH,SAVEDOTDODOTXT_0001 # if
	.word XT_RAM_BUF
	.word XT_RAMDOTP
	.word XT_FETCH
	.word XT_PLUS
	.word XT_STORE
	.word XT_SAVEDOTCACHEPLUSPLUSBANG
	.word XT_DOBRANCH,SAVEDOTDODOTXT_0002
SAVEDOTDODOTXT_0001: # else
	STRING "FAIL "
	.word XT_TYPE
	.word XT_SAVEDOTIP
	.word XT_FETCH
	.word XT_FETCH
	.word XT_XT2STRING
	.word XT_TYPE
	STRING "not in FLASH"
	.word XT_TYPE
	.word XT_CR
	.word XT_SAVEDOTUNWIND
	.word XT_ABORT
SAVEDOTDODOTXT_0002: # then
	.word XT_SAVEDOTIPPLUSPLUS
	.word XT_EXIT
# ----------------------------------------------------------------------
COLON "save.rom", SAVEDOTROM 
	.word XT_STARTDOTFLASHDOTP
	.word XT_FETCH
	.word XT_CELLPLUS
	.word XT_DOLITERAL
	.word XT_FORTH_WORDLIST
	.word XT_CELLPLUS
	.word XT_FETCH
	.word XT_STORE
	.word XT_SAVEDOTIP
	.word XT_FETCH
	.word XT_SAVEDOTLFA
	.word XT_FETCH
	.word XT_MINUS
	.word XT_STARTDOTFLASHDOTP
	.word XT_FETCH
	.word XT_PLUS
	.word XT_TOFLASH_P
	.word XT_ROM_TO_RAM
	.word XT_FORTH_WORDLIST
	.word XT_RAM_BUF
	.word XT_FETCH
	.word XT_MINUS
	.word XT_RAM_BUF
	.word XT_CELLPLUS
	.word XT_STORE
	.word XT_FLASH_P
	.word XT_RAM_BUF
	.word XT_TWO
	.word XT_CELLS
	.word XT_PLUS
	.word XT_FETCH
	.word XT_MINUS
	.word XT_RAM_BUF
	.word XT_DOLITERAL
	.word 3
	.word XT_CELLS
	.word XT_PLUS
	.word XT_STORE
	.word XT_RAMHERE
	.word XT_RAM_BUF
	.word XT_FOUR
	.word XT_CELLS
	.word XT_PLUS
	.word XT_FETCH
	.word XT_MINUS
	.word XT_RAM_BUF
	.word XT_DOLITERAL
	.word 5
	.word XT_CELLS
	.word XT_PLUS
	.word XT_STORE
	.word XT_ROMHERE
	.word XT_RAM_BUF
	.word XT_DOLITERAL
	.word 6
	.word XT_CELLS
	.word XT_PLUS
	.word XT_FETCH
	.word XT_MINUS
	.word XT_RAM_BUF
	.word XT_DOLITERAL
	.word 7
	.word XT_CELLS
	.word XT_PLUS
	.word XT_STORE
	.word XT_RAM_TO_ROM
	.word XT_EXIT
# ----------------------------------------------------------------------
COLON "save.colon", SAVEDOTCOLON # ( ffa -- ) SAVE: save a colon word (subword in save)
	.word XT_FFA2LFA
	.word XT_DUP
	.word XT_SAVEDOTIP
	.word XT_STORE
	.word XT_SAVEDOTLFA
	.word XT_STORE
	.word XT_FALSE
	.word XT_SAVEDOTDONEQ
	.word XT_STORE
	.word XT_FLASH_TO_RAM
	.word XT_FLASH_P
	.word XT_DOLITERAL
	.word 0xff
	.word XT_AND
	.word XT_RAMDOTP
	.word XT_STORE
	.word XT_FLASH_P
	.word XT_STARTDOTFLASHDOTP
	.word XT_STORE
	STRING "Saving >> "
	.word XT_TYPE
	.word XT_SAVEDOTLFA
	.word XT_FETCH
	.word XT_LFA2FFA
	.word XT_FFAGTXT
	.word XT_XT2STRING
	.word XT_TYPE
	STRING " << "
	.word XT_TYPE
SAVEDOTCOLON_0001: # begin
	.word XT_SAVEDOTIP
	.word XT_FETCH
	.word XT_DOLITERAL
	.word XT_SAVEDOTLFAQ
	.word XT_OVER
	.word XT_SWAP
	.word XT_EXECUTE
	.word XT_DOCONDBRANCH,SAVEDOTCOLON_0002 # if
	.word XT_DROP
	.word XT_SAVEDOTDODOTLFA
	.word XT_DOBRANCH,SAVEDOTCOLON_0003
SAVEDOTCOLON_0002: # else
	.word XT_DOLITERAL
	.word XT_SAVEDOTFFAQ
	.word XT_OVER
	.word XT_SWAP
	.word XT_EXECUTE
	.word XT_DOCONDBRANCH,SAVEDOTCOLON_0004 # if
	.word XT_DROP
	.word XT_SAVEDOTDODOTFFA
	.word XT_DOBRANCH,SAVEDOTCOLON_0005
SAVEDOTCOLON_0004: # else
	.word XT_DOLITERAL
	.word XT_SAVEDOTNFAQ
	.word XT_OVER
	.word XT_SWAP
	.word XT_EXECUTE
	.word XT_DOCONDBRANCH,SAVEDOTCOLON_0006 # if
	.word XT_DROP
	.word XT_SAVEDOTDODOTNFA
	.word XT_DOBRANCH,SAVEDOTCOLON_0007
SAVEDOTCOLON_0006: # else
	.word XT_DOLITERAL
	.word XT_COLONQ
	.word XT_OVER
	.word XT_SWAP
	.word XT_EXECUTE
	.word XT_DOCONDBRANCH,SAVEDOTCOLON_0008 # if
	.word XT_DROP
	.word XT_SAVEDOTDODOTCOLON
	.word XT_DOBRANCH,SAVEDOTCOLON_0009
SAVEDOTCOLON_0008: # else
	.word XT_DOLITERAL
	.word XT_LITERALQ
	.word XT_OVER
	.word XT_SWAP
	.word XT_EXECUTE
	.word XT_DOCONDBRANCH,SAVEDOTCOLON_000A # if
	.word XT_DROP
	.word XT_SAVEDOTDODOTLIT
	.word XT_DOBRANCH,SAVEDOTCOLON_000B
SAVEDOTCOLON_000A: # else
	.word XT_DOLITERAL
	.word XT_XLITERALQ
	.word XT_OVER
	.word XT_SWAP
	.word XT_EXECUTE
	.word XT_DOCONDBRANCH,SAVEDOTCOLON_000C # if
	.word XT_DROP
	.word XT_SAVEDOTDODOTXLIT
	.word XT_DOBRANCH,SAVEDOTCOLON_000D
SAVEDOTCOLON_000C: # else
	.word XT_DOLITERAL
	.word XT_SLITERALQ
	.word XT_OVER
	.word XT_SWAP
	.word XT_EXECUTE
	.word XT_DOCONDBRANCH,SAVEDOTCOLON_000E # if
	.word XT_DROP
	.word XT_SAVEDOTDODOTSLIT
	.word XT_DOBRANCH,SAVEDOTCOLON_000F
SAVEDOTCOLON_000E: # else
	.word XT_DOLITERAL
	.word XT_ANYBRANCHQ
	.word XT_OVER
	.word XT_SWAP
	.word XT_EXECUTE
	.word XT_DOCONDBRANCH,SAVEDOTCOLON_0010 # if
	.word XT_DROP
	.word XT_SAVEDOTDODOTBRA
	.word XT_DOBRANCH,SAVEDOTCOLON_0011
SAVEDOTCOLON_0010: # else
	.word XT_DOLITERAL
	.word XT_EXITQ
	.word XT_OVER
	.word XT_SWAP
	.word XT_EXECUTE
	.word XT_DOCONDBRANCH,SAVEDOTCOLON_0012 # if
	.word XT_DROP
	.word XT_SAVEDOTDODOTEXIT
	.word XT_DOBRANCH,SAVEDOTCOLON_0013
SAVEDOTCOLON_0012: # else
	.word XT_DOLITERAL
	.word XT_SAVEDOTANYQ
	.word XT_OVER
	.word XT_SWAP
	.word XT_EXECUTE
	.word XT_DOCONDBRANCH,SAVEDOTCOLON_0014 # if
	.word XT_DROP
	.word XT_SAVEDOTDODOTXT
	.word XT_DOBRANCH,SAVEDOTCOLON_0015
SAVEDOTCOLON_0014: # else
	.word XT_DROP
SAVEDOTCOLON_0015: # then
SAVEDOTCOLON_0013: # then
SAVEDOTCOLON_0011: # then
SAVEDOTCOLON_000F: # then
SAVEDOTCOLON_000D: # then
SAVEDOTCOLON_000B: # then
SAVEDOTCOLON_0009: # then
SAVEDOTCOLON_0007: # then
SAVEDOTCOLON_0005: # then
SAVEDOTCOLON_0003: # then
	.word XT_SAVEDOTDONEQ
	.word XT_FETCH
	.word XT_DOCONDBRANCH,SAVEDOTCOLON_0001 # until
	.word XT_SAVEDOTROM
	STRING "SUCCESS"
	.word XT_TYPE
	.word XT_CR
	.word XT_EXIT
# ----------------------------------------------------------------------
COLON "save.var", SAVEDOTVAR 
	.word XT_FFA2LFA
	.word XT_DUP
	.word XT_SAVEDOTIP
	.word XT_STORE
	.word XT_SAVEDOTLFA
	.word XT_STORE
	.word XT_FALSE
	.word XT_SAVEDOTDONEQ
	.word XT_STORE
	.word XT_FLASH_TO_RAM
	.word XT_FLASH_P
	.word XT_DOLITERAL
	.word 0xff
	.word XT_AND
	.word XT_RAMDOTP
	.word XT_STORE
	.word XT_FLASH_P
	.word XT_STARTDOTFLASHDOTP
	.word XT_STORE
	STRING "Saving >> "
	.word XT_TYPE
	.word XT_SAVEDOTLFA
	.word XT_FETCH
	.word XT_LFA2FFA
	.word XT_FFAGTXT
	.word XT_XT2STRING
	.word XT_TYPE
	STRING " << "
	.word XT_TYPE
	.word XT_SAVEDOTDODOTLFA
	.word XT_SAVEDOTDODOTFFA
	.word XT_SAVEDOTDODOTNFA
	.word XT_SAVEDOTLINEPLUSPLUS
	.word XT_SAVEDOTLINEPLUSPLUS
	.word XT_RAM_TO_FLASH
	.word XT_SAVEDOTROM
	STRING "SUCCESS"
	.word XT_TYPE
	.word XT_CR
	.word XT_EXIT
# ----------------------------------------------------------------------
COLON "save.how", SAVEDOTHOW 
	.word XT_TO_R
	.word XT_R_FETCH
	.word XT_FFA2CFA
	.word XT_VARIABLEQ
	.word XT_DOCONDBRANCH,SAVEDOTHOW_0001 # if
	.word XT_R_FETCH
	.word XT_SAVEDOTVAR
	.word XT_RDROP
	.word XT_FINISH
SAVEDOTHOW_0001: # then
	.word XT_R_FETCH
	.word XT_FFA2CFA
	.word XT_COLONQ
	.word XT_DOCONDBRANCH,SAVEDOTHOW_0002 # if
	.word XT_R_FETCH
	.word XT_SAVEDOTCOLON
	.word XT_RDROP
	.word XT_FINISH
SAVEDOTHOW_0002: # then
	.word XT_EXIT
# ----------------------------------------------------------------------
COLON "save.inner", SAVEDOTINNER 
	.word XT_DUP
	.word XT_FFA2LFA
	.word XT_FETCH
	.word XT_ZEROEQUAL
	.word XT_DOCONDBRANCH,SAVEDOTINNER_0001 # if
	.word XT_COMMA
	.word XT_FALSE
	.word XT_DOBRANCH,SAVEDOTINNER_0002
SAVEDOTINNER_0001: # else
	.word XT_COMMA
	.word XT_TRUE
SAVEDOTINNER_0002: # then
	.word XT_EXIT
# ----------------------------------------------------------------------
COLON "save.list", SAVEDOTLIST 
	.word XT_HERE
	.word XT_TO_R
	.word XT_DOLITERAL
	.word XT_SAVEDOTINNER
	.word XT_RAM_WORDLIST
	.word XT_TRAVERSEWORDLIST
	.word XT_2DROP
	.word XT_HERE
SAVEDOTLIST_0001: # begin
	.word XT_CELLMINUS
	.word XT_DUP
	.word XT_DUP
	.word XT_FETCH
	.word XT_SAVEDOTHOW
	.word XT_R_FETCH
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,SAVEDOTLIST_0001 # until
	.word XT_DROP
	.word XT_RDROP
	.word XT_EXIT
# ----------------------------------------------------------------------
COLON "save", SAVE # ( "name" -- ) SAVE: save "name" in RAM or all in RAM to FLASH 
	.word XT_PARSENAME
	.word XT_DUP
	.word XT_DOCONDBRANCH,SAVE_0001 # if
	.word XT_FINDXT
	.word XT_DOCONDBRANCH,SAVE_0002 # if
	.word XT_DUP
	.word XT_RAMDOTXTQ
	.word XT_DOCONDBRANCH,SAVE_0003 # if
	.word XT_XT2FFA
	.word XT_SAVEDOTHOW
	.word XT_DOBRANCH,SAVE_0004
SAVE_0003: # else
	.word XT_DROP
	STRING "name not found in RAM dictionary"
	.word XT_TYPE
	.word XT_CR
SAVE_0004: # then
	.word XT_DOBRANCH,SAVE_0005
SAVE_0002: # else
	STRING "name not found in ANY dictionary"
	.word XT_TYPE
	.word XT_CR
SAVE_0005: # then
	.word XT_DOBRANCH,SAVE_0006
SAVE_0001: # else
	.word XT_RAM_WORDLIST
	.word XT_ZEROEQUAL
	.word XT_DOCONDBRANCH,SAVE_0007 # if
	STRING "RAM dictionary empty"
	.word XT_TYPE
	.word XT_CR
	.word XT_DOBRANCH,SAVE_0008
SAVE_0007: # else
	STRING "Saving entire RAM dictionary..."
	.word XT_TYPE
	.word XT_CR
	.word XT_SAVEDOTLIST
SAVE_0008: # then
SAVE_0006: # then
	.word XT_EXIT
# ----------------------------------------------------------------------
