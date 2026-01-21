# AmForth 32-bit

This is the shared basis of all 32-bit versions of AmForth.

Words in core/words are combined with ARM/RISC-V architecture specific words (rv/words, arm/words, ...)
and with architecture compatible MCU specific words, e.g.
* core/words/ + rv/words + rv/mcu/hifive1/words (HiFive board), or
* core/words/ + arm/words + arm/mcu/lm4f120/words (Stellaris Launchpad board)

# Architecture

## Memory layout

### Code Flash Memory / ROM

This is persistent, executable memory that contains primarily the predefined AmForth words. The end of the used part of this memory is tracked by the `dp.flash` pointer. User defined words can be copied from RAM into the code flash memory with the word `save`. This will allow the word to survive a hardware reset.

### RAM

This non-peristent, executable memory used for multiple purposes. It is divided into 2 sections `amramlo` and `amramhi`.

`amramlo` is used to support runtime needs of AmForth, it houses things like the parameter and return stacks, user block, system buffers etc.

`amramhi` is again divided into 2 sections.

`amramhi` lower part is used for variable values and other application uses. The end of the used part of this section is tracked with `vp` pointer.

`amramhi` higher part stores definitions of user defined words. The end of the used part of this section is tracked with `dp.ram` pointer.

### Data Flash Memory / EEPROM

This is persistent, non-executable memory. It used to persist AmForth values and other application uses. Design yet to be finalized.


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
core                = core AmForth files; shared by all architectures and mcus
├── dev
│   └── Makefile    = shared build targets
├── amforth32.ld    = shared linker file; defines the 32-bit memory layout (SECTIONS)
├── amforth32.s     = shared assembler file; early 32-bit architecture setup
├── config.inc      = core configuration parameters
├── dict_env.inc    = includes shared environment wordlist words
├── dict_prims.inc  = includes common primary words required by core/words (see [1])
├── dict_secs.inc   = includes all secondary core/words; define most of core functionality
├── macros.inc      = shared macros (e.g. dictionary); included by arch macros.inc
├── readme.md
└── user.inc        = shared user area words

arm                 = ARM Cortex-M based MCUs
├── amforth.s       = template main source file to be used to start new boards
├── dev
│   └── Makefile    = ARM targets, e.g. toolchain
├── mcu
│   ├── lm4f120            = TI's LM4F Series MCU & Stellaris® LM4F120 LaunchPad
│   │   ├── amforth.s      = main mcu source file
│   │   ├── config.inc     = MCU configuration, includes core/config.inc
│   │   ├── dict_mcu.inc   = mcu specific words
│   │   ├── stellaris.ld   = mcu linker file defines MEMORY, and INCLUDEs core/amforth32.ld
│   │   ├── Makefile       = MCU targets, e.g. upload, run, debug
│   │   └── readme
│   ├── linux              = generic linux/raspberry Pi
│   └── ra4m1              = Renesas RA4M1 & Arduino Uno R4 board
├── arch_prims.inc  = includes ARM specific words
├── interpreter.s = inner interpreter for ARM
└── macros.inc      = ARM specific macros; includes core/macros.inc

rv                  = RISC-V based MCUs
├── amforth.s       = template main source file to be used to start new boards
├── dev
│   └── Makefile    = RISC-V targets, e.g. toolchain
├── mcu
│   ├── ch32v307    = WCH CH32V307 board
│   └── hifive1     = HiFive board
├── arch_prims.inc  = includes RISC-V specific words
├── interpreter.s = inner interpreter for RISC-V
└── macros.inc      = RISC-V specific macros; includes core/macros.inc
```

[1] dict_prims.inc includes interpreter.s so that the interpreter code resides in the middle of the prim words (cpu caching reasons);
    it also includes arch_prims.inc so that arm/rv can add more generic architecture prim words
[2] produced with % tree --prune -I 'words|build|dev|touch1200bps' core arm rv

## Directory conventions

words/ - source files of forth words, colon words and code words
dev/ - supporting utilities for AmForth development, e.g. gdb extensions, shared Makefile bits, etc.
tools/ - runnable tools aimed for various supporting tasks, communication, docs, etc (preferably written in Python)
build/ - directory for compilation artifacts, excluded from the repository

## File conventions

*.s, *.S       = assembler source files, either code-words (assembler), or colon-words (ITC assembler)
amforth.s      = the main AmForth source file (usually one for each MCU)
*.inc          = include files; shouldn't contain code, just directives and constant definitions
dict_*.inc     = shared lists of AmForth words, define how the dictionary is laid out in flash memory
arch_*.inc     = additional words specific to MCU architecture, follows the prims words in flash memory
mcu/*.inc      = config files for specific boards/targets
amforth32.ld   = the main linker file; defines the basic AmForth 32-bit memory layout
*.ld           = MCU/board specific linker file; configures amforth32.ld options and specifies MEMORY parameters

# Linker files

The assembly of AmForth is controlled by linker files. The core linker file `amforth32.ld` defines the memory layout described above. The MCU linker files include this file to ensure the basic structure of the memory layout is the same everywhere. This provides firm foundation for the large number of shared core words.

## Using Linker Symbols

Note that while symbols defined in linker files can be referenced in assembler files, their nature constrains their usage.
Primarily it means that they cannot be used as immediate values.

This is because the assembler processes source code before the linker, so it can't resolve symbols defined only in the linker script when used as immediates. Immediates must be known at assembly time, while linker symbols are resolved later during linking. Using linker symbol improperly fails with confusing error "Unknown symbol". The issue might be that the symbol exists but is used improperly (in a way that would require embedding it into the instruction opcode, as opposed to an instruction argument).