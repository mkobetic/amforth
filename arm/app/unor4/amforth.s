
.globl PFA_COLD 

.include "config.inc"
.include "macros.inc"
.include "user.inc"

.equ WANT_IGNORECASE, 0

.syntax unified
.cpu cortex-m4
.thumb

.section .vector, "ax"
.include "vectors.s"

.section amforth, "ax"
.include "isr.s"

STARTDICT

.include "dict_prims.inc"
.include "dict_secs.inc"
.include "dict_env.inc"
.include "dict_appl.inc"

ENDDICT
