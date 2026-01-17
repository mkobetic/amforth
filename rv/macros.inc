# SPDX-License-Identifier: GPL-3.0-only

.include "common/macros.inc"


# macros
#   s5/SP RSP Return Stack Pointer
#   s3 TOS Top Of Stack
#   s4 DSP Data Stack Pointer
#   t0 temp 
#   t1 temp
#   t2 temp
#   s7 loop index
#   s8 loop limit
#   a0..a5 temp
#   s2 IP  Forth VM IP register (ITC Instruction Pointer)
#   s1 W   Forth VM W register
#   s6 user pointer UP

.macro NEXT
    j DO_NEXT
.endm

.macro savetos
  addi s4, s4, -4
  sw s3, 0(s4)
.endm

.macro loadtos
  lw s3, 0(s4)
  addi s4,s4,4
.endm

.macro push register
  addi s5, s5, -4
  sw \register, 0(s5)
.endm

.macro pop register
  lw \register, 0(s5)
  addi s5, s5, 4
.endm

.macro pushdouble register1 register2
  addi s5, s5, -8  
  sw \register1, 4(s5)
  sw \register2, 0(s5)  
.endm

.macro popdouble register1 register2
  lw \register1, 4(s5)
  lw \register2, 0(s5)
  addi s4, s4, 8
.endm

.macro pushda register # Push register on Datastack
  savetos
  mv s3, \register    
.endm

.macro popda register # Pop register from Datastack
  mv \register, s3
  loadtos
.endm

.macro pushdadouble register1 register2 # Push register on Datastack
  addi s4, s4, -8
  sw s3, 4(s4)
  sw \register1, 0(s4)
  mv s3, \register2
.endm

.macro popdadouble register1 register2 # Pop register from Datastack
  mv \register1, s3
  lw \register2, 0(s4)
  lw s3, 4(s4)
  addi s4, s4, 8
.endm

.macro ENDDICT
  ENDDICT_ARCH riscv
.endm

# =====================
# CSR are RISC-V specific registers
# =====================

.macro CSR NUM, Name
  ARCH_HEADER Flag_visible, "\Name", CSR_\Name, PFA_CSR_\Name
    savetos
    csrr s3, \NUM
  NEXT
.endm


  