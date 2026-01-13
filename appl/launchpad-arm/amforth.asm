

.syntax unified
.cpu cortex-m4
.thumb

.text

.equ RamStart, 0x20000000
.equ RamEnd,   0x20008000

.equ FlashStart,  0x00004000
.equ FlashEnd,    0x00040000

.equ datastack_size, 128   
.equ returnstack_size, 128 
.equ refill_buf_size, 96
.equ appl_userarea_size, 8 
.equ leavestack_size, 8*cellsize

.equ WANT_IGNORECASE, 0

.include "macros.s"

.include "preamble.inc"
.include "user.inc"
.include "common/vectors.s"

@ move past the vector table space
.org 0x400

.include "common/isr.s"

STARTDICT

.include "dict_prims.inc"
.include "dict_secs.inc"
.include "dict_env.inc"

.include "dict_appl.inc"

ENDDICT
