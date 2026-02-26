# AmForth 32-bit

This is the shared basis of all 32-bit versions of AmForth.

AmForth is assembled by combining the words in `core/words/` with ARM/RISC-V architecture specific words (`rv/words/`, `arm/words/`)
and with architecture compatible MCU specific words, e.g.
* core/words/ + rv/words/ + rv/mcu/hifive1/words/ (HiFive board), or
* core/words/ + arm/words/ + arm/mcu/lm4f120/words/ (Stellaris Launchpad board)

Specific word files are selected by `dict_*.inc` files. The main file that pulls everything together is MCU specific `amforth.s` file,
e.g. `arm/mcu/ra4m1/amforth.s`.

The build process is driven by Makefile targets in `core/dev/Makefile`. Use `make help` or just `make` to see the list
of available targets with brief descriptions. Architecture or MCU specific Makefiles add targets that are specific to that level.


# Architecture

## Memory layout

The overall memory layout is defined by the main `core/amforth32.ld` linker file that defines the memory sections (see comments in the file for more details on specific sections). It is included by MCU specific linker files that define the physical memory regions that the sections are allocated in, for example `arm/mcu/ra4m1/unor4.ld`. If there are multiple build targets for a given MCU, there will be a dedicated linker file for each target (see `make help` for the list of targets for a given MCU).

This arrangement ensures that the basic structure of the memory layout is the same everywhere and provides firm foundation for the large number of shared core words.

### FLASH region

This is persistent, executable memory region that contains primarily the predefined AmForth words. The end of the used part of this region is tracked by the `dp.flash` pointer. User defined words can be compiled into FLASH when the compilation mode is set to FLASH using the `>flash` word. Words compiled into FLASH are tracked by the `forth-wordlist`.

For some, usually emulated, MCU targets, the FLASH region can be allocated in volatile RAM memory. However in these cases runtime updates in FLASH will not persist through resets and restarts of the system.

### PVFLASH region

This is persistent data memory region used to store update records for persistent values, `pvalues`. Sufficient amount of PVFLASH is required for the `>flash` mode to work correctly. Without it AmForth is unable to remember new words compiled into FLASH across resets/restarts of the system.

PVFLASH region can be allocated in regular code flash memory, usually at the end of it, to allow the runtime FLASH dictionary to grow up to it. For more information on `pvalues` see the comments in `core/words/pvalue.s`.

### RAM region

This is non-peristent, executable memory used for multiple purposes. It is divided into multiple sections, sometimes subdivided into parts with different purposes.

New words can also be compiled into the RAM dictionary when the mode is set to RAM using the `>ram` word. Such words will not persist, but this mode is very useful for development of new words, when many iterations of the same words need to be compiled and tested. This would use up space in the persistent FLASH memory relatively quickly, space that can only be reclaimed by erasing the FLASH and re-uploading AmForth from scratch.

Section `amramlo` is used for RAM allocated by the predefined AmForth words. This includes parameter and return stacks, user block, system buffers etc.

Section `amramhi` is used for RAM allocated at runtime.

The lower part of `amramhi`, the RAM pool, is used for RAM allocated for words that are compiled into FLASH at runtime (variables, values, defers, etc). The end of the used part of this section is tracked by the `vp` pointer.

The higher part of `amramhi` is used for the RAM dictionary, i.e. the words compiled into RAM at runtime. The end of the used part of this section is tracked by the `dp.ram` pointer. The words of the RAM dictionary are tracked by the `ram-wordlist`.

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

## Wordlists and Search Orders

A wordlist maintains a pointer to the latest word added to it, specifically it points to the last word's FFA. The full list of the words can be traversed by following the chain of LFA pointers in the words. The predefined wordlists are
* `environment` - a predefined wordlist containing words describing the AmForth system itself (a standard Forth wordlist)
* `core-wordlist` - contains the pre-compiled core words
* `forth-wordlist` - contains words compiled to FLASH at runtime, it also includes the `core-wordlist`
* `ram-wordlist` - contains words compiled to RAM at runtime, this wordlist is always empty when the system starts up

A `wid`, referenced by stack signatures of some words, is the XT of a wordlist word, e.g. `forth-wordlist`. The `current` value contains the `wid` of the wordlist that new words are compiled into. When switching between FLASH and RAM mode `current` will be set to the corresponding wordlist.

A search order is a list of wordlists to be searched for an existing word. Search orders are primarily used to look for known words when new word definitions are compiled. The search order that is used for these lookups is held by the `cfg-order` deferred word. There are several pre-defined search orders
* `order.core`  - `core-wordlist`, `environment`
* `order.forth` - `forth-wordlist`, `environment`
* `order.core`  - `ram-wordlist`, `forth-wordlist`, `environment`
These orders can be assigned to `cfg-order` with words `core`, `forth` and `only`. `order.forth` is used when in FLASH mode, and `order.only` is used when in RAM mode. Changing the order is important to avoid compiling FLASH words with references to RAM words, which would yield corrupt FLASH words after restart.


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

The assembly of AmForth is controlled by linker files. The core linker file `amforth32.ld` defines the memory layout described above. The MCU linker files primarily define the specific memory regions of the corresponding target/board and include `amforth32.ld` to allocate the required memory sections.

## Using Linker Symbols

Note that while symbols defined in linker files can be referenced in assembler files, their nature constrains their usage.
Primarily it means that they cannot be used as immediate values.

This is because the assembler processes source code before the linker, so it can't resolve symbols defined only in the linker script when used as immediates. Immediates must be known at assembly time, while linker symbols are resolved later during linking. Using linker symbol improperly fails with confusing error "Unknown symbol". The issue might be that the symbol exists but is used improperly (in a way that would require embedding it into the instruction opcode, as opposed to an instruction argument).

# Development

## Tools

### Toolchain

* TC_DIR
* Local toolchain `make toolchain`
* Arduino IDE toolchain

### Running

* amforth-shell.py

Use `make shell` tu run it (first set MODEM to point at the serial device)

Requires Python3 and pyserial package. If `pip3 install pyserial` gives you `error: externally-managed-environment`, and 
you don't want heed its warnings and deal with Python virtual environments, then `pip3 install --user --break-system-packages pyserial` should be a relatively safe resolution.

### Debugging

* GDB
* OpenOCD

### Uploaders, other MCU specific tools

## Testing

## Emulation Tests

Large amount of core functionality can be tested with QEMU emulation.
Linux based targets can run on qemu-user on Linux or in Docker on MacOS.
These tests run automatically on every commit pushed to github.

QEMU is best installed with the OS package manager (homebrew on Mac)
* requires qemu-system-arm for ARM MCUs
* requires qemu-system-risc32 for RISC-V MCUs
* The Makefile `tests` target requires the `timeout` command to force QEMU to terminate,
  it is native on linux, install coreutils on Mac to get it
* It uses `awk` script to parse out the test results