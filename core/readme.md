# AmForth 32-bit

This is the shared basis of all 32-bit versions of AmForth.

Words in core/words are combined with architecture specific words (rv/words, arm/words, ...)
and with architecture compatible application/board specific words, e.g.
* core/words/ + rv/words + rv/app/hifive1/words (HiFive board), or
* core/words/ + arm/words + arm/app/launchpad/words (Launchpad Stellaris board)

# Architecture

## Memory layout

### Code Flash Memory / ROM

This is persistent, executable memory that contains primarily the predefined AmForth words. The end of the used part of this memory is tracked by the `dp.flash` pointer. User defined words can be copied from RAM into the code flash memory with the word `save`. This will allow the word to survive a hardware reset.

### RAM

This a non-peristent, executable memory used for multiple purposes. It is divided into 2 sections RAMLO and RAMHI.

RAMLO is used to support runtime needs of AmForth, it houses things like the parameter and return stacks, user block, system buffers etc.

RAMHI is again divided into 2 sections.

RAMHI lower part is used for variable values and other application uses. The end of the used part of this section is tracked with `vp` pointer.

RAMHI higher part stores definitions of user defined words. The end of the used part of this section is tracked with `dp.ram` pointer.

### Data Flash Memory / EEPROM

This is a persistent, non-executable memory. It used to persist AmForth values and other application uses. Design yet to be finalized.


## Dictionary word layout

The 32-bit word header layout is somewhat different from the 8-bit word layout. The header field order is different.
In AmForth the execution token (XT) is the CFA.

| Field | Size   | Description
| ----- | ------ | ----------------------------------
| LFA   | .word  | (LFA) points to FFA of prior word
| FFA   | .word  | (FFA) word flags
| NFA   | .bytes | (NFA) length prefixed string containing the name of the word
| CFA   | .word  | (CFA) points to executable code implementing the word
|       |        | for code-words (CFA) = PFA
| PFA   | .bytes | (PFA) word parameters compiled into the word definition
|       |        | for colon-words PFA is a sequence of .words interpreted by the inner interpreter ending with XT_EXIT
|       |        | for code-words PFA is machine code implementing the word ending with NEXT macro expansion
|       |        | for other word types the contents of PFA can be interpreted in completely arbitrary way

Words that are compiled into the AmForth binary have corresponding symbols defined that map to:
* LFA - VE_ symbol
* CFA - XT_ symbol
* PFA - PFA_ sybmol

## Wordlists and Search Order

To be continued


# AmForth directory layout

The picture below shows the relevant bit of directory structure with the words/ directories stripped out.

```
% tree --prune -I 'words|build|dev|devices|touch1200bps' core arm rv

core                = core AmForth files; shared by all architectures and apps
├── amforth32.ld    = shared linker file; defines the 32-bit memory layout (SECTIONS)
├── common
│   └── macros.inc  = shared macros (e.g. dictionary); included by arch macros.inc
├── config.inc      = basic configuration parameters referenced by core/words
├── dict_env.inc    = includes shared environment wordlist words
├── dict_prims.inc  = includes common primary words required by core/words (see [1])
├── dict_secs.inc   = includes all secondary core/words; define most of core functionality
├── readme.md
└── user.inc        = shared user area words

arm                 = ARM Cortex-M based MCUs
├── amforth.s       = template main source file to be used to start new boards
├── app
│   ├── launchpad           = Launchpad Stellaris board 
│   │   ├── amforth.s       = main app source file
│   │   ├── dict_appl.inc   = app specific words
│   │   ├── launchpad.ld    = app linker file defines MEMORY, and INCLUDEs core/amforth32.ld
│   │   ├── Makefile
│   │   └── readme
│   ├── linux               = generic linux/raspberry Pi
│   └── unor4               = Arduino Uno R4 board
├── arch_prims.inc  = includes ARM specific words
├── common          = common source files to be included by apps
├── interpreter.inc = inner interpreter for ARM
└── macros.inc      = ARM specific macros; includes core/common/macros.inc

rv                  = RISC-V based MCUs
├── amforth.s       = template main source file to be used to start new boards
├── app
│   ├── ch32v307    = WCH CH32V307 board
│   └── hifive1     = HiFive board
├── arch_prims.inc  = includes RISC-V specific words
├── interpreter.inc = inner interpreter for RISC-V
└── macros.inc      = RISC-V specific macros; includes core/common/macros.inc
```

[1] dict_prims.inc includes interpreter.inc so that the interpreter code resides in the middle of the prim words (cpu caching reasons);
    it also includes arch_prims.inc so that arm/rv can add more generic architecture prim words

## Directory conventions

words/ - source files of forth words, colon words and code words
common/ - files intended for inclusion at lower levels
dev/ - supporting utilities for AmForth development, e.g. gdb extensions, shared Makefile bits, etc.
tools/ - runnable tools aimed for various supporting tasks, communication, docs, etc (preferably written in Python)
build/ - directory for compilation artifacts, excluded from the repository

## File conventions

*.s, *.S       = assembler source files, either code-words (assembler), or colon-words (ITC assembler)
amforth.s      = the main AmForth source file (usually one for each MCU)
*.inc          = include files; shouldn't contain code, just directives and constant definitions
dict_*.inc     = shared lists of AmForth words, defines how the dictionary is laid out in flash
arch_*.inc     = additional words specific to architecture, follows the prims words in flash
app/*.inc      = config files for specific boards/targets
amforth32.ld   = the main linker file; defines the basic AmForth 32-bit memory layout
*.ld           = MCU/board specific linker file; configures amforth32.ld options and specifies MEMORY parameters

# Linker files

The assembly of AmForth is controlled by linker files. The core linker file `amforth32.ld` defines the memory layout described above. The board/application linker files include this file to ensure the basic structure of the memory layout is the same everywhere. This provides firm foundation for the large number of shared core words.

## Using Linker Symbols

Note that while symbols defined in linker files can be referenced in assembler files, their nature constraints their usage.
Primarily it means that they cannot be used as immediate values.

This is because the assembler processes source code before the linker, so it can't resolve symbols defined only in the linker script when used as immediates (e.g. refill_buf_size). Immediates must be known at assembly time, while linker symbols are resolved later during linking. Consequently following ARM instruction will fail with "Unknown symbol"

```asm
    cmp tos, #refill_buf_size
```

Instead the symbol must be used as an address argument, so the workaround is something like

```asm
    ldr     r3, =refill_buf_size
    cmp     tos, r3
```

This works because `ldr r3, =refill_buf_size` creates a load instruction with a placeholder that the linker fills in with the actual value from the script.

Consequently constants that are not related to the memory layout are better defined in assembler files to avoid this constraint.
