
.include "config.inc"
.include "build-config.inc"
.include "arm/macros.inc"
.include "user.inc"

.syntax unified

.align 4
.text
.global _start
_start:
  ldr r0, =PFA_ARGV  @ Save the initial stack pointer, as it contains
  str sp, [r0]       @ command line arguments. Do this only once on first entry.

  ldr r0, =PFA_COLD+1
  bx r0 @ Switch to thumb mode
.thumb

.section amforth, "awx" @ Everything is writeable and executable

STARTDICT

.include "dict_prims.inc"
.include "dict_secs.inc"
.include "dict_env.inc"
.include "dict_mcu.inc"

ENDDICT
