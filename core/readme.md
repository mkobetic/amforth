# AmForth 32-bit

This directory contains the shared basis of all 32-bit versions of AmForth.

AmForth is assembled by combining the words in `core/words/` with ARM/RISC-V architecture specific words (`rv/words/`, `arm/words/`)
and with architecture compatible MCU specific words, e.g.
* core/words/ + rv/words/ + rv/mcu/hifive1/words/ (HiFive board), or
* core/words/ + arm/words/ + arm/mcu/lm4f120/words/ (Stellaris Launchpad board)

Specific word files are selected by `dict_*.inc` files. The main file that pulls everything together is MCU specific `amforth.s` file, e.g. `arm/mcu/ra4m1/amforth.s`.

The build process is driven by Makefile commands in `core/dev/Makefile`. Use `make help` or just `make` (executed in an MCU directory) to see the list of available commands with brief descriptions. Architecture or MCU specific `Makefiles` add commands that are specific to that level. Comments in the `Makefiles` provide further details.

# Architecture

Most of the original AmForth [Architecture](https://amforth.sourceforge.net/TG/Architecture.html) and [Compiler](https://amforth.sourceforge.net/TG/Compiler.html) documentation applies to AmForth32 as well. This document primarily elaborates on what is different in AmForth32.

## Memory layout

The overall memory layout is defined by the main `core/amforth32.ld` linker file that defines the memory sections (see comments in the file for more details on specific sections). It is included by MCU specific linker files defining the physical memory regions that the sections are allocated in, for example `arm/mcu/ra4m1/unor4.ld`. If there are multiple build targets for a given MCU, there will be a dedicated linker file for each target (see `make help` for the list of recognized targets for a given MCU).

This arrangement ensures that the basic structure of the memory layout is the same everywhere and provides firm foundation for the large number of shared core words.

### FLASH region

This is persistent, executable memory region that contains primarily the predefined AmForth words. The end of the used part of this region is tracked by `dp.flash`. User defined words can be compiled into FLASH when the compilation mode is set to FLASH using the `>flash` word. Words compiled into FLASH are tracked by `forth-wordlist`.

For some, usually emulated, MCU targets, the FLASH region can be allocated in transient RAM memory. However in these cases runtime updates in FLASH will not persist through resets and restarts of the system.

### PVFLASH region

This is persistent data memory region used to store update records for persistent values, `pvalues`. Sufficient amount of PVFLASH is required for the `>flash` mode to work correctly. Without it AmForth is unable to remember new words compiled into FLASH across resets/restarts of the system.

PVFLASH region can be allocated in regular code flash memory, usually at the end of it, to allow the runtime FLASH dictionary to grow up to it. For more information on `pvalues` see the comments in `core/words/pvalue.s`.

### RAM region

This is non-peristent, executable memory used for multiple purposes. It is divided into multiple sections, sometimes subdivided into parts with different purposes.

New words can also be compiled into the RAM dictionary when the mode is set to RAM using the `>ram` word. Such words will not persist, but this mode is very useful for development of new words, when many iterations of the same words need to be compiled and tested. This would use up space in the persistent FLASH memory relatively quickly, space that can only be reclaimed by erasing the FLASH and re-uploading AmForth from scratch.

Section `amramlo` is used for RAM allocated by the predefined AmForth words. This includes parameter and return stacks, user block, system buffers etc.

Section `amramhi` is used for RAM allocated at runtime.

The lower part of `amramhi`, the RAM pool, is used for RAM allocated for words that are compiled into FLASH at runtime (variables, values, defers, etc). The end of the used part of this section is tracked by `vp`.

The higher part of `amramhi` is used for the RAM dictionary, i.e. words compiled into RAM at runtime. The end of the used part of this section is tracked by `dp.ram`. The words of the RAM dictionary are tracked by `ram-wordlist`.

## Dictionary layout

The 32-bit word header layout is somewhat different from the 8-bit word layout. The header field order is different.
The header and all its fields are always `cellsize` aligned.

In AmForth the execution token (XT) is the CFA.

| Field | Size   | Description
| ----- | ------ | ----------------------------------
| LFA   | .word  | link field: points to FFA of prior word
| FFA   | .word  | flag field: word flags
| NFA   | .bytes | name field: length prefixed string containing the name of the word padded to cell alignment
| CFA   | .word  | code field: points to executable code implementing the word
|       |        | for code-words (CFA) = PFA
| PFA   | .bytes | parameter field: word parameters compiled into the word definition
|       |        | for colon-words PFA is a sequence of .words interpreted by the inner interpreter ending with XT_EXIT
|       |        | for code-words PFA is machine code implementing the word ending with NEXT macro expansion
|       |        | for other word types the contents of PFA can be interpreted in completely arbitrary way

Words that are pre-compiled into the AmForth binary have corresponding address symbols defined that map to:
* LFA - VE_ symbol
* CFA - XT_ symbol
* PFA - PFA_ symbol

## Wordlists and search order

A wordlist maintains a pointer to the latest word added to it, specifically it points to the last word's FFA. The full list of the words can be traversed by following the chain of LFA pointers in the words. The predefined wordlists are
* `environment` - a predefined wordlist containing words describing the AmForth system itself (a standard Forth wordlist)
* `core-wordlist` - contains the pre-compiled core words
* `forth-wordlist` - contains words compiled to FLASH at runtime, it also includes the `core-wordlist`
* `ram-wordlist` - contains words compiled to RAM at runtime, this wordlist is always empty when the system starts up

A `wid`, referenced by stack signatures of some words, is the XT of a wordlist word, e.g. `forth-wordlist`. The `current` value contains the `wid` of the wordlist that new words are compiled into. When switching between FLASH and RAM mode `current` will be set to the corresponding wordlist.

A search order is a list of wordlists to be searched for an existing word. Search order is primarily used to look for known words when new word definitions are compiled. Current search order that is used for these lookups is dictated by `cfg-order`. There are several pre-defined search orders
* `order.core`  - `core-wordlist`, `environment`
* `order.forth` - `forth-wordlist`, `environment`
* `order.only`  - `ram-wordlist`, `forth-wordlist`, `environment`

These orders can be assigned to `cfg-order` with words `core`, `forth` and `only`. `order.forth` is used when in FLASH mode, and `order.only` is used when in RAM mode. Changing the order is important to avoid compiling FLASH words with references to RAM words, which would yield corrupted FLASH words after restart.


# Directory layout

The picture below shows the relevant bits of the AmForth directory structure [^2] with `words/` and other directories stripped out.

```
core                = core AmForth files; shared by all architectures and MCUs
├── dev             = development utilities
│   ├── categories  = defines refcard categories and order
│   └── Makefile    = shared build targets (included by MCU Makefile)
├── amforth32.ld    = shared linker file; defines the 32-bit memory layout (SECTIONS)
├── amforth32.s     = shared assembler file; early build-time setup
├── build-config.inc  = assembles final BUILD_CONFIG flags value
├── config.inc      = core configuration parameters (included by MCU config.inc)
├── dict_env.inc    = includes shared environment wordlist words
├── dict_prims.inc  = includes common primary words required by other core/words (see [^1])
├── dict_secs.inc   = includes all secondary core/words; defines most of core functionality
├── macros.inc      = shared macros (e.g. dictionary); included by arch macros.inc
└── user.inc        = shared user area words

arm                 = ARM Cortex-M based MCUs
├── amforth.s       = template main source file to be used to start new boards
├── dev             = development utilities
│   └── Makefile    = ARM targets, e.g. toolchain (included my MCU Makefile)
├── mcu
│   ├── linux              = generic linux/raspberry Pi
│   ├── lm4f120            = TI's LM4F Series MCU & Stellaris® LM4F120 LaunchPad
│   │   ├── amforth.s      = main MCU source file
│   │   ├── config.inc     = MCU configuration, includes core/config.inc
│   │   ├── dict_mcu.inc   = MCU specific words
│   │   ├── stellaris.ld   = MCU linker file defines MEMORY, and INCLUDEs core/amforth32.ld
│   │   ├── Makefile       = MCU targets, e.g. upload, run, debug
│   │   └── readme
│   ├── qemu               = ARM QEMU -M virt target
│   └── ra4m1              = Renesas RA4M1 & Arduino Uno R4 board
├── amforth.s       = template for new ARM MCUs
├── arch_prims.inc  = includes ARM specific words
├── interpreter.s   = inner interpreter for ARM
└── macros.inc      = ARM specific macros; includes core/macros.inc

rv                  = RISC-V based MCUs
├── amforth.s       = template main source file to be used to start new boards
├── dev
│   └── Makefile    = RISC-V targets, e.g. toolchain
├── mcu
│   ├── ch32v307    = WCH CH32V307 board
│   ├── hifive1     = HiFive board
│   └── qemu        = RISC-V QEMU -M virt target
├── amforth.s       = template for new RISC-V MCUs
├── arch_prims.inc  = includes RISC-V specific words
├── interpreter.s   = inner interpreter for RISC-V
└── macros.inc      = RISC-V specific macros; includes core/macros.inc
```

[^1]: `dict_prims.inc` includes `interpreter.s` so that the interpreter code resides in the middle of the prim words (cpu caching reasons);
    it also includes `arch_prims.inc` so that arm/rv can add more generic architecture prim words

[^2]: initially generated with `tree --prune -I 'words|build|dev|touch1200bps' core arm rv`

## Directory conventions

* `words/`: source files of forth words
* `dev/`: supporting utilities for AmForth development, e.g. gdb extensions, shared Makefile bits, etc.
* `tools/`: runnable tools aimed for various supporting tasks, communication, docs, etc (preferably written in Python)
* `build/`: directory for compilation artifacts, excluded from the repository

## File conventions

Words can be implemented in two ways: native assembler code, or universal ITC code.

Native assembler words, also called code-words are specific to given CPU architecture. This form is used mainly for the primary words, the basic operations that need to be reimplemented for every CPU architecture.

Universal ITC words, also called colon-words, are implemented only once and can be executed on any CPU architecture. This form is used primarily for the secondary words, i.e. words that are implemented using other words. The ITC code is technically also assembler, but it doesn't use assembler instructions.
Instead it mimics the result of compiling a word written in Forth, and thus is basically a data structure from assembler's point of view.

* `*.s, *.S`: assembler source files, either code-words (assembler), or colon-words (ITC assembler)
* `amforth.s`: the main AmForth source file (usually one for each MCU)
* `*.inc`: include files; shouldn't contain code, just directives and constant definitions
* `dict_*.inc`: shared lists of AmForth word files, define the contents of the pre-compiled dictionary
* `arch_*.inc`: includes additional words specific to MCU architecture, follows the prims words in flash memory
* `mcu/*.inc`: config files for specific boards/targets
* `amforth32.ld`: the main linker file; defines the basic AmForth 32-bit memory layout
* `*.ld`: MCU target/board specific linker file; configures amforth32.ld options and defines the MEMORY regions

# Linker files

The final assembly of AmForth binary is controlled by linker files. The core linker file `amforth32.ld` defines the memory layout described above. The MCU linker files primarily define the specific memory regions of the corresponding target/board and include `amforth32.ld` to allocate the required memory sections.
There will be a separate linker file for each MCU target.

## Linker symbols

Note that while symbols defined in linker files can be referenced in assembler files, their nature constrains their usage.
Primarily it means that they cannot be used as immediate values in assembler code.

This is because the assembler processes source code before the linker, so it can't resolve symbols defined only in the linker script when used as immediates. Immediates must be known at assembly time, while linker symbols are resolved later during linking. Using linker symbol improperly fails with confusing error `"Unknown symbol"`. The issue might be that the symbol exists but is used improperly (in a way that would require embedding it into the instruction opcode, as opposed to an instruction "argument" that the linker can handle).

# Code conventions

Every pre-compiled word should have a comment on the same line as the word definition macro containing the stack signature and short description. This line is used to generate the reference card. Example:
```
CODEWORD "rdepth", RDEPTH /* ( -- n ) n is current dept of the return stack */
```
The comment must use the `/* .. */` format to be compatible with both ARM and RV assembler. A longer description optionally follows this header line, again enclosed in `/* .. */`.

`#` can be used as comment marker when it is the first character on the line, or the first character after the label.

The word definition must end with the `END` macro (it allows emitting proper function blocks for words). The `END` macro requires the same symbol argument that was used to start the word definition.

`NONAME` and `HEADLESS` macro invocations must include a name argument. The name is not included in the word definition but it is used when transpiling Forth code to ITC. `NONAME` and `HEADLESS` words are excluded from the reference card, but should still have the standard comment line.


