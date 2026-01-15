# SPDX-License-Identifier: GPL-3.0-only

.equ cellsize, 4

# start of flash dictionary. The 0 is the stop marker.
.macro STARTDICT
  # .text should aready be in section amforth
  .p2align 2,0x55
# Inject a NOP word as the first entry in the dictionary.
  .word 0
97: # arch-wordlist
98: # environment
99: # forth-wordlist
VE_NOP: .word 0
        .byte 8f-7f
7:      .ascii "nop"
8:      .p2align 2,0xAA
XT_NOP: .word PFA_NOP
PFA_NOP:
        NEXT 
.endm

# save the beginning of the wordlists
.macro ENDDICT_ARCH ARCH
VALUE "\ARCH-wordlist", ARCH_WORDLIST, 97b
VALUE "environment", ENVIRONMENT, 98b
VALUE "forth-wordlist", FORTH_WORDLIST, 99b
.set core_wordlist , 99b
.set DPSTART, 99b
.endm

.macro STRING string
    .word XT_DOSLITERAL
    .byte 8f - 7f
7:  .ascii "\string"
8:  .p2align 2,0x0f
.endm

.equ Flag_cloaked,    0x80000000
.equ Flag_visible,    0x00000000

.equ Flag_immediate,  0x0010
.equ Flag_value,      0x0020
.equ Flag_defer,      0x0040
.equ Flag_init,       0x0080
.equ Flag_table,      0x0100

# Ramallot means that RAM is reserved and initialised by catchflashpointers for this definition on startup
.equ Flag_ramallot,   Flag_visible | 0x0100 
# How many 32 bit locations shall be reserved ?     
.equ Flag_variable,   Flag_ramallot| 1           
.equ Flag_2variable,  Flag_ramallot| 2
.equ Flag_colon   ,   Flag_visible | 4 
.equ Flag_constant,   Flag_visible | 8 

.macro HEADER Flags, Name, Label, PFA
    .p2align 2,0x55
VE_\Label:
    .word 99b /* LFA: Link to FFA of previous word */
    # FFA: Flag field 
99: .word \Flags
    # NFA: Name field
    # Calculate length of name field
    .byte 8f - 7f
    # Insert name string
7:  .ascii "\Name"
    # Realign
8:  .p2align 2,0xaa   
   XT_\Label: .word \PFA
   PFA_\Label: 
.endm

.macro CODEWORD Name, Label
    HEADER Flag_visible, "\Name", \Label, PFA_\Label
.endm

.macro CLOAKED_CODEWORD Name, Label
    HEADER Flag_visible | Flag_cloaked, "\Name", \Label, PFA_\Label
.endm

# HIDEWORD is a CODEWORD with Flag_invisible
# suspect I have made this visible again as
# whatever I was trying did not work and I
# did not want to go an edit all the files
# again to replace HIDEWORD with CODEWORD 
.macro HIDEWORD Name, Label
    HEADER Flag_visible, "\Name", \Label, PFA_\Label
.endm

.macro HEADLESS Label
  .p2align 2,0x55
   XT_\Label: .word PFA_\Label
   PFA_\Label: 
.endm

.macro COLON Name, Label
    HEADER Flag_colon, "\Name", \Label, DOCOLON
.endm

.macro CLOAKED_COLON Name, Label
    HEADER Flag_colon | Flag_cloaked, "\Name", \Label, DOCOLON
.endm

.macro NONAME Label
  .p2align 2,0x55
   XT_\Label: .word DOCOLON
   PFA_\Label: 
.endm

.macro IMMED Name, Label
    HEADER Flag_visible|Flag_immediate, \Name, \Label, DOCOLON
.endm

.macro VARIABLE Name, Label
    HEADER Flag_visible|Flag_variable, "\Name", \Label, PFA_DOVARIABLE
    .section amramlo,"aw",%nobits
    .balign 4
     # Capture current location counter
    .set \Label\()_ram, .          
    .space 4
    .section amforth
    # Write the captured address into flash
    .word \Label\()_ram             
.endm

.macro CLOAKED_VARIABLE Name, Label
   HEADER Flag_visible|Flag_variable|Flag_cloaked, "\Name", \Label, PFA_DOVARIABLE
    .section amramlo,"aw",%nobits
    .balign 4
    # Capture current location counter
    .set \Label\()_ram, .           
    .space 4
    .section amforth
    # Write the captured address into flash
    .word \Label\()_ram             
.endm

.macro DVARIABLE Name, Label
   HEADER Flag_visible|Flag_variable, "\Name", \Label, PFA_DOVARIABLE
    .section amramlo,"aw",%nobits
    .balign 4
    # Capture current location counter
    .set \Label\()_ram, .           
    .space 8
    .section amforth
    # Write the captured address into flash
    .word \Label\()_ram             
.endm

.macro NVARIABLE Name, Label, N
  HEADER Flag_visible|Flag_variable, "\Name", \Label, PFA_DOVARIABLE
    .section amramlo,"aw",%nobits
    .balign 4
    # Capture current location counter
    .set \Label\()_ram, .          
    .space 4*\N
    .section amforth
    # Write the captured address into flash
    .word \Label\()_ram            
.endm

.macro CLOAKED_DVARIABLE Name, Label
   HEADER Flag_visible|Flag_variable|Flag_cloaked, "\Name", \Label, PFA_DOVARIABLE
    .section amramlo,"aw",%nobits
    .balign 4
    # Capture current location counter
    .set \Label\()_ram, .           
    .space 8
    .section amforth
    # Write the captured address into flash
    .word \Label\()_ram             
.endm

.macro USER Name, Label, UOffset
   HEADER Flag_visible|Flag_variable, "\Name", \Label, PFA_DOUSER
   .word \UOffset
   # for symbol listing
   .equ USER_\Label,\UOffset 
.endm

.macro VALUE Name, Label, Default
    HEADER Flag_visible|Flag_value|Flag_init, "\Name", \Label, PFA_DOVALUE
   .section amramlo,"aw",%nobits
   .balign 4
    # Capture current location counter
   .set \Label\()_ram, .          
   .space 4
   .section amforth
   # Write the captured address into flash
   .word \Label\()_ram             
   .word \Default
   .word XT_FETCH
   .word XT_STORE
.endm

.macro CLOAKED_VALUE Name, Label, Default
    HEADER Flag_visible|Flag_value|Flag_init|Flag_cloaked, "\Name", \Label, PFA_DOVALUE
   .section amramlo,"aw",%nobits
   .balign 4
   # Capture current location counter
   .set \Label\()_ram, .           
   .space 4
   .section amforth
   # Write the captured address into flash
   .word \Label\()_ram             
   .word \Default
   .word XT_FETCH
   .word XT_STORE
.endm

# .macro ALTVAL Name, Label, Default
#     HEADER Flag_visible|Flag_value|Flag_init, "\Name", \Label, PFA_DOVALUE
#    .word rampointer
#     .equ RAM_\Label,rampointer # for listing
#    .set rampointer, rampointer+4
#    .word rom_pointer
#    .section amrom,"ax"
#    .word \Default
#    .section amforth,"ax"
# #   .set keep , .
# #   .org rom_pointer
# #   .word \Default
# #   .org keep
#    .set rom_pointer , rom_pointer + 4
#    .word XT_FETCH
#    .word XT_STORE
# .endm

.macro DEFER Name, Label, XT
    HEADER Flag_visible|Flag_defer|Flag_init, "\Name", \Label, PFA_DODEFER
   .section amramlo,"aw",%nobits
   .balign 4
   # Capture current location counter
   .set \Label\()_ram, .           
   .space 4
   .section amforth
   # Write the captured address into flash
   .word \Label\()_ram             
   .word \XT
   .word XT_FETCH
   .word XT_STORE
.endm

.macro CLOAKED_DEFER Name, Label, XT
    HEADER Flag_visible|Flag_defer|Flag_init|Flag_cloaked, "\Name", \Label, PFA_DODEFER
   .section amramlo,"aw",%nobits
   .balign 4
   # Capture current location counter
   .set \Label\()_ram, .           
   .space 4
   .section amforth
   # Write the captured address into flash
   .word \Label\()_ram             
   .word \XT
   .word XT_FETCH
   .word XT_STORE
.endm

# see user.inc for valid labels
.macro UDEFER Name, Label, XT
    HEADER Flag_visible|Flag_defer|Flag_init, "\Name", \Label, PFA_DODEFER
   .word USER_\Label 
   .word \XT
   .word XT_UDEFER_FETCH
   .word XT_UDEFER_STORE
.endm

.macro CONSTANT Name, Label, NUM
#    HEADER Flag_visible, "\Name", \Label, PFA_DOVARIABLE
    HEADER Flag_constant, "\Name", \Label, PFA_DOVARIABLE
    .word \NUM
.endm

.macro CLOAKED_CONSTANT Name, Label, NUM
#    HEADER Flag_visible, "\Name", \Label, PFA_DOVARIABLE
    HEADER Flag_constant|Flag_cloaked, "\Name", \Label, PFA_DOVARIABLE
    .word \NUM
.endm

.macro CON Name, NUM
    CONSTANT "\Name" , "\Name" , \NUM
.endm

.macro DATA Name, Label
    HEADER Flag_visible, "\Name", \Label, PFA_DODATA
.endm


# ===================
# environment contains colon words only
# ===================

.macro ENVIRONMENT Name, Label
    .p2align 2,0xf0
VE_ENV_\Label:
    # LFA: Insert Link
    .word 98b          
98: # FFA: Flag field
    .word Flag_visible
    # NFA: Name field
    # Calculate length of name field
    .byte 8f - 7f     
    # Insert name string
7:  .ascii "\Name"
    # Realign
8:  .p2align 2,0xf0        
XT_ENV_\Label: .word DOCOLON
PFA_ENV_\Label:
.endm

# ================================
# Arch Wordlist Entry
# different types
# ================================

.macro ARCH_HEADER Flags, Name, Label, PFA
    .p2align 2,0xf0
VE_\Label:
    # LFA: Insert Link
    .word 97b          
97: # FFA: Flag field
    .word \Flags
    # NFA: Name field
    # Calculate length of name field
    .byte 8f - 7f     
    # Insert name string
7:  .ascii "\Name"
    # Realign
8:  .p2align 2,0xf0        
XT_\Label: .word \PFA
PFA_\Label: 
.endm


  