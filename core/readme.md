# AmForth 32-bit

This directory contains the shared basis of all 32-bit versions of AmForth.

AmForth is assembled by combining the words in `core/words/` with ARM/RISC-V architecture specific words (`rv/words/`, `arm/words/`)
and with architecture compatible MCU specific words, e.g.
* core/words/ + rv/words/ + rv/mcu/hifive1/words/ (HiFive board), or
* core/words/ + arm/words/ + arm/mcu/lm4f120/words/ (Stellaris Launchpad board)

Specific word files are selected by `dict_*.inc` files. The main file that pulls everything together is MCU specific `amforth.s` file,
e.g. `arm/mcu/ra4m1/amforth.s`.

The build process is driven by Makefile targets in `core/dev/Makefile`. Use `make help` or just `make` (executed in an MCU directory) to see the list of available targets with brief descriptions. Architecture or MCU specific `Makefiles` add targets that are specific to that level. Comments in the `Makefiles` provide further details. 

# Architecture

## Memory layout

The overall memory layout is defined by the main `core/amforth32.ld` linker file that defines the memory sections (see comments in the file for more details on specific sections). It is included by MCU specific linker files that define the physical memory regions that the sections are allocated in, for example `arm/mcu/ra4m1/unor4.ld`. If there are multiple build targets for a given MCU, there will be a dedicated linker file for each target (see `make help` for the list of targets for a given MCU).

This arrangement ensures that the basic structure of the memory layout is the same everywhere and provides firm foundation for the large number of shared core words.

### FLASH region

This is persistent, executable memory region that contains primarily the predefined AmForth words. The end of the used part of this region is tracked by `dp.flash`. User defined words can be compiled into FLASH when the compilation mode is set to FLASH using the `>flash` word. Words compiled into FLASH are tracked by the `forth-wordlist`.

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

The higher part of `amramhi` is used for the RAM dictionary, i.e. words compiled into RAM at runtime. The end of the used part of this section is tracked by `dp.ram`. The words of the RAM dictionary are tracked by the `ram-wordlist`.

## Dictionary word layout

The 32-bit word header layout is somewhat different from the 8-bit word layout. The header field order is different.
In AmForth the execution token (XT) is the CFA.

| Field | Size   | Description
| ----- | ------ | ----------------------------------
| LFA   | .word  | link field: points to FFA of prior word
| FFA   | .word  | flag field: word flags
| NFA   | .bytes | name field: length prefixed string containing the name of the word
| CFA   | .word  | code field: points to executable code implementing the word
|       |        | for code-words (CFA) = PFA
| PFA   | .bytes | parameter field: word parameters compiled into the word definition
|       |        | for colon-words PFA is a sequence of .words interpreted by the inner interpreter ending with XT_EXIT
|       |        | for code-words PFA is machine code implementing the word ending with NEXT macro expansion
|       |        | for other word types the contents of PFA can be interpreted in completely arbitrary way

Words that are compiled into the AmForth binary have corresponding address symbols defined that map to:
* LFA - VE_ symbol
* CFA - XT_ symbol
* PFA - PFA_ symbol

## Wordlists and Search Order

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


# AmForth directory layout

The picture below shows the relevant bit of directory structure [^2] with the words/ directories stripped out.

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
├── dict_prims.inc  = includes common primary words required by core/words (see [^1])
├── dict_secs.inc   = includes all secondary core/words; define most of core functionality
├── macros.inc      = shared macros (e.g. dictionary); included by arch macros.inc
├── readme.md
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
│   └── hifive1     = HiFive board
├── amforth.s       = template for new RISC-V MCUs
├── arch_prims.inc  = includes RISC-V specific words
├── interpreter.s   = inner interpreter for RISC-V
└── macros.inc      = RISC-V specific macros; includes core/macros.inc
```

[^1]:  `dict_prims.inc` includes `interpreter.s` so that the interpreter code resides in the middle of the prim words (cpu caching reasons);
    it also includes `arch_prims.inc` so that arm/rv can add more generic architecture prim words

[^2]: produced with `% tree --prune -I 'words|build|dev|touch1200bps' core arm rv`

## Directory conventions

* `words/`: source files of forth words, colon words and code words
* `dev/`: supporting utilities for AmForth development, e.g. gdb extensions, shared Makefile bits, etc.
* `tools/`: runnable tools aimed for various supporting tasks, communication, docs, etc (preferably written in Python)
* `build/`: directory for compilation artifacts, excluded from the repository

## File conventions

* `*.s, *.S`: assembler source files, either code-words (assembler), or colon-words (ITC assembler)
* `amforth.s`: the main AmForth source file (usually one for each MCU)
* `*.inc`: include files; shouldn't contain code, just directives and constant definitions
* `dict_*.inc`: shared lists of AmForth words, define how the dictionary is laid out in flash memory
* `arch_*.inc`: additional words specific to MCU architecture, follows the prims words in flash memory
* `mcu/*.inc`: config files for specific boards/targets
* `amforth32.ld`: the main linker file; defines the basic AmForth 32-bit memory layout
* `*.ld`: MCU target/board specific linker file; configures amforth32.ld options and specifies MEMORY parameters

# Linker files

The assembly of AmForth is controlled by linker files. The core linker file `amforth32.ld` defines the memory layout described above. The MCU linker files primarily define the specific memory regions of the corresponding target/board and include `amforth32.ld` to allocate the required memory sections.

## Linker symbols

Note that while symbols defined in linker files can be referenced in assembler files, their nature constrains their usage.
Primarily it means that they cannot be used as immediate values in assembler code.

This is because the assembler processes source code before the linker, so it can't resolve symbols defined only in the linker script when used as immediates. Immediates must be known at assembly time, while linker symbols are resolved later during linking. Using linker symbol improperly fails with confusing error "Unknown symbol". The issue might be that the symbol exists but is used improperly (in a way that would require embedding it into the instruction opcode, as opposed to an instruction "argument" that the linker can handle).


# Development

The development setup revolves around the MCU directories. This is where the make commands are to be executed. `make all` will produce a number of build artifacts in the `build/` subdirectory (excluded from git), including the hex, bin and elf files containing AmForth compiled for a given target. `make` or `make help` shows the available targets for a given MCU. To build a different target than the default one, run `make all` with `TARGET` environment variable set accordingly, e.g. `TARGET=XXX make all`.

To allow for personalized development settings, the `Makefiles` optionally include `.env` file (excluded from git) if it is present in the MCU directory. Note that the `.env` file is interpreted as a Makefile, therefore it must follow Makefile syntax. It is useful to override default settings or provide required settings that don't change much to avoid having to provide them on the command line on each invocation. An `.env` file could look as follows:
```
# MODEM is required by `make shell` and directs amforth-shell.py to connect to the specified TTY
MODEM ?= /dev/cu.usbmodemXXX
# If you want to override the toolchain to use for Amforth build, TC_DIR and CROSS are variables that control that
TC_DIR = $(AMFORTH)/toolchain/riscv-none-elf-15.2.0-1
CROSS = riscv-none-elf-
# amforth-shell.py uses the EDITOR variable when it attempts to open an external editor
export EDITOR=code
```
The Makefiles set most variables with `?=`, therefore most can be overridden by the `.env` file. Read the Makefile comments for more details.

The Makefiles provide `AMFORTH` variable as convenient way to point to the directory where the AmForth repository was cloned.

## Tools

### Toolchain

The toolchain is generally the standard GNU assembler/linker/debugger suite tailored for given embedded architecture. For ARM it is the `arm-none-eabi` variant, and for RISC-V it is the `riscv-none-elf` variant. The toolchain can be installed in many different ways. Variables `TC_DIR` and `CROSS` allow connecting the AmForth build system to a pre-installed toolchain.

For example if you are using Arduino IDE for some development on a given board, you can point `TC_DIR` at the location where Arduino IDE installed this toolchain. The `CROSS` variable defines the common prefix that the toolchain binaries use, e.g. `arm-none-eabi-` when the assembler binary is named `arm-none-eabi-as`.

Command `make toolchain` is a convenient way to install the right toolchain in the AmForth directory itself. This keeps the host system unaffected. The toolchain will be installed in `$(AMFORTH)/toolchain/` directory. Multiple local toolchains can be installed, e.g. both the ARM and the RISCV toolchain can be installed at the same time and the make commands will use the right one depending on which MCU directory they are executed in. The default build system setup expects this configuration of the toolchain. This configuration is also used by the CI for testing and release building.

### Running AmForth

#### Physical boards

To run AmForth on a physical board, the usual sequence is straightforward
* `make all` - to build the bin or hex file
* `make upload` - to upload the file to the board (this requires board specific upload tool)
* `make shell` - to connect `amforth-shell.py` to the board (`MODEM` variable needs to point at the board's PTY device)

You can use any terminal emulator to connect to AmForth, but it is highly recommended to use `amforth-shell.py` because it provides a number of AmForth
specific highly useful conveniences that will be lacking with other emulators.

`amforth-shell.py` requires Python3 and the `pyserial` package. Python3 is often pre-installed by the host OS, if it isn't follow the recommended installation approach for your OS. The `pyserial` package usually needs to be installed with `pip3 install pyserial` command. If this gives you `error: externally-managed-environment`, and you don't want to heed its warnings and deal with Python virtual environments, then `pip3 install --user --break-system-packages pyserial` should be a relatively safe work-around.

#### QEMU

AmForth provides a number of emulated build targets. With these you do not upload AmForth binary file, instead you execute the `amforth.elf` file with the corresponding variant of the QEMU emulator. Use the recommended installation path for your OS to install QEMU. For ARM you will need `qemu-system-arm`, for RISC-V you will need `qemu-system-riscv32`.

There are several ways to run AmForth under QEMU, the `Makefiles` usually provide following options.
* `make stdio` - starts AmForth connected directly to the stdio of the terminal running the command; you don't need a terminal emulator in this case, but you only get very basic interaction capabilities
* `make pty` - starts AmForth connected to a PTY device (very much like when it's running on a physical board); the terminal stdio is connected to the QEMU monitor allowing control of the emulation process; QEMU will output the name of the PTY device on startup, set the `MODEM` variable to that and start `amforth-shell.py` with `make shell`

Finally the Linux based targets (e.g. `arm/mcu/linux`) can run on `qemu-user` on Linux or in Docker on other operating systems.

### Debugging

* GDB
* OpenOCD

### Uploaders, other MCU specific tools

## Testing

Testing on physical boards is currently a manual process. There isn't any automation available for that at this time.

However AmForth does have a suite of tests that can run on emulated targets fairly easily. This test suite is based on the standard Forth testing framework and includes the standard Forth test suite as well. The test suite files are in `$(AMFORTH)/tests` directory. 

To run the test suite, the target has to be built with `WANT_IGNORECASE` option set. This is because the standard test suite
is written in all-caps and AmForth words are all in lowercase. This option allows words to match regardless of the case.

The `make tests` command runs the full test suite assuming a QEMU target compiled with `WANT_IGNORECASE`. For example, to run
the test suite on the `arm/mcu/qemu` target, following steps would be used.
* `WANT_IGNORECASE=1 make all`
* `make tests`

The command analyses the output of the test run and summarizes the test results. An `awk` script is used to parse the test output. Awk is usually preinstalled on the host OS, if not use the OS package manager to install it.

Any test failures will be emitted in the output showing the test that failed and the incorrect output it produced. The command emits a final test summary showing the number of tests passed and failed and whether the whole suite completed. Summary of a successful test run can looks something like this
```
qemu-system-arm: terminating on signal 15 from pid 17281 (<unknown process>)
FINISHED: Y, PASS: 635, FAIL: 0
```

The termination warning is there because the test command must kill the QEMU process at the end, otherwise it would not quit. The test command gives the QEMU process predefined amount of time (e.g. 5 seconds) to run through the test suite and then kills it. It detects from the test output whether the whole test suite ran in that time or not. The `timeout` command is used to control the QEMU process. This command is native on Linux, on other OSes install `coreutils` to get it.

AmForth CI runs this test suite on every new commit pushed to GitHub. It runs it twice, once in normal build configuration and once with `WANT_ITC` build configuration. When `WANT_ITC` option is set the build prefers the core/words ITC version of words over the native assembler version if both exist (normally it is the other way around). This makes sure both versions are exposed to the test suite in the CI tests.