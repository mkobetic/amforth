# This is a template to start from.
# Copy it into your appl/ directory and modify as needed.

.globl PFA_COLD 

.include "config.inc"
.include "macros.inc"
.include "user.inc"

.syntax unified
.cpu cortex-m4
.thumb

.section .vector, "ax"
.include "common/vectors.s" 

.section amforth, "ax"
.include "common/isr.s"

STARTDICT

.include "dict_prims.inc"
.include "dict_secs.inc"
.include "dict_env.inc"

.include "dict_appl.inc"

ENDDICT
