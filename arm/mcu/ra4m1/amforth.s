
.globl PFA_COLD 

.include "config.inc"
.include "arm/macros.inc"
.include "user.inc"

.syntax unified
.cpu cortex-m4
.thumb

.section .vector, "ax"
.include "mcu/ra4m1/vectors.s"

.section amforth, "ax"
.include "mcu/ra4m1/isr.s"

STARTDICT

.include "dict_prims.inc"
.include "dict_secs.inc"
.include "dict_env.inc"
.include "dict_mcu.inc"

ENDDICT
