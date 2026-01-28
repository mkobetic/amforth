
.include "core/macros.inc"

@ register usage
@ temporary r0, r1, r2, r3, r4, r5

tos     .req r6
psp     .req r7
FORTHW  .req r8
FORTHIP .req r9
UP      .req r10
rloopindex .req r11
rlooplimit .req r12

@ default register mapping
@ sp .req r13  @ rsp (return stack pointer)
@ lr .req r14
@ pc .req r15

.macro NEXT
    b DO_NEXT
    .ltorg
.endm

.macro savetos @ Push TOS on Datastack - a common, often used factor.
    str tos, [psp, #-4]!
.endm

.macro loadtos
    ldr tos, [psp], #4
.endm

// push register to the data stack (n2 n1 -- n2 n1 reg)
.macro pushtos register
  savetos
  mov tos, \register
.endm

// pop register from data stack (n2 n1 reg -- n2 n1)
.macro poptos register
  mov \register, tos
  loadtos
.endm

// push register under tos, leave tos as is (n2 n1 -- n2 reg n1)
.macro pushnos register
  str \register, [psp, #-4]!
.endm

// pop nos into register, leave tos as is (n2 reg n1 -- n2 n1)
.macro popnos register
  ldr \register, [psp], #4
.endm

.macro throw exception
  savetos               /* for good order        */
  ldr tos, =\exception   /* load exception number */
  ldr FORTHW, =XT_THROW  /* load XT of THROW to W reg */
  b DO_EXECUTE          /* execute via ITC VM    */
.endm

.macro ENDDICT
  ENDDICT_ARCH arm
.endm

@ ================================
@ ARM Wordlist Entry
@ different types
@ ================================

.macro ARM_COLON Name, Label
    ARCH_HEADER Flag_visible, "\Name", \Label, DOCOLON
.endm

.macro ARM_CONSTANT Name, Label, NUM
    ARCH_HEADER Flag_visible, "\Name", \Label, PFA_DOVARIABLE
    .word \NUM
.endm


@ ==================================
@ Debug Macro. Not used in production
@ ==================================
.macro SEMIT register
.ifdef DEBUG
   push {r0}
0: 
   ldr r0, =UARTFR
   ldr r0, [r0]
   ands r0, #TXFF
   bne 0b

   ldr r0, =UARTDR
   str \register, [r0]
   pop {r0}
.endif
.endm
