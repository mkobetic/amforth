# AmForth 32-bit

This is the shared basis of all 32-bit versions of AmForth.

Words in shared/words are combined with architecture specific words (RISC-V/words, ARM/words, ...)
and with architecture compatible application/board specific words, e.g.
* rv/words + appl/hifive1/words, or
* arm/words + appl/launchpad-arm/words

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

The picture below shows the relevant bit of directory structure with the words/ directories stripped out, annotated to provide some rationale.

```
% tree --prune -I 'words|build|dev|devices|touch1200bps' appl/ch32v307 appl/launchpad-arm appl/unor4 arm rv shared

appl/ch32v307
├── amforth.S ; main board file
├── clock.K
├── config.inc ; board configuration
├── dict_appl.inc ; board specific words
├── dict_min.inc
├── linker.307  ; linker files largely just define MEMORY, and INCLUDE shared/amforth32.ld with the SECTIONS
├── linker.qem
├── main.S
├── Makefile
├── startup.307
└── startup.qem
appl/launchpad-arm
├── amforth.asm
├── dict_appl.inc
├── flash.s
├── launchpad.ld ; linker file including shared/amforth32.ld
├── Makefile
├── readme
└── vectors.s
appl/unor4
├── amforth.s
├── dict_appl.inc
├── flash.s
├── isr.s
├── Makefile
├── notes.md
├── ra4m1.ld ; linker file including shared/amforth32.ld
├── readme
└── vectors.s
arm
├── amforth.s ; template file to be used for new boards
├── arch_prims.inc ; architecture specific words
├── common ; these files are in common directory so that they can be included by the corresponding board files
│   ├── isr.s
│   └── vectors.s
├── interpreter.inc ; inner interpreter code
└── macros.inc ; architecture specific macros; includes shared/common/macros.inc
rv
├── amforth.s ; template file to be used for new boards
├── arch_prims.inc ; architecture specific words
├── interpreter.inc ; inner interpreter code
└── macros.inc ; architecture specific macros; includes shared/common/macros.inc
shared
├── amforth32.ld ; shared linker file defining the 32-bit memory layout
├── common ; again common directory so that arch specific macros.inc can import this macros.inc
│   └── macros.inc
├── config.inc ; basic configuration parameters referenced by shared/words
├── dict_env.inc ; shared env dictionary words
├── dict_prims.inc ; common primitive words used by shared/words (see [1])
├── dict_secs.inc ; all the secondary shared/words
├── readme.md
└── user.inc ; shared user dictionary words
```

[1] the dict_prims.inc includes interpreter.inc so that the interpreter code still resides in the middle of the prim words (cpu caching reasons);
     it also includes arch_prims.inc so that arm/rv can add more prim words


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
