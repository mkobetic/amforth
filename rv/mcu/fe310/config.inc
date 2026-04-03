
.include "core/config.inc"

.equ datastack_size, 32 * cellsize
.equ returnstack_size, 32 * cellsize

/* TODO: this is made up, needs correcting */ 
.equ flash_page, 1*1024
.equ flash_cell, 1
.equ flash_erased, 0xFFFFFFFF /* a word in erased flash */

.equ rampool_size, 1024*1

.equ WANT_DEBUGGER       , YES
.equ WANT_IGNORECASE     , YES
.equ WANT_SEE            , YES
.equ WANT_TRANSPILER     , NO

