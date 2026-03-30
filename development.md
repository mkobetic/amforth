# Development

The development setup revolves around the MCU directories. This is where the make commands must be executed. `make all` will produce a number of build artifacts in the `build/` subdirectory (excluded from git), including the hex, bin and elf files containing AmForth compiled for given target. `make` or `make help` shows the available targets for given MCU. To build a different target than the default one, run `make all` with `TARGET` environment variable set accordingly, e.g. `TARGET=XXX make all`. 

The build process produces following files in the `build/` directory:

#### Binary Files
* amforth.bin - binary file for uploads into physical board
* amforth.hex - Intel hex file for uploads into physical board
* amforth.elf - executable for emulation

#### Build Files
* amforth.dep - list of files used in the build
* amforth.map - linker map of the executable
* amforth.sym - list of all symbols of the executable
* amforth.lst - assembler listing from the linker
* amforth.lst-as - assembler listing from the assembler
* amforth.sal - symbol and source line listing (debug info)

#### Documentation Files
* amforth.html - reference card of all words in this build
* amforth.txt - reference card of all words in this build
* amforth.toc - list of headers of all words in this build


### Customizing setup

To allow for personalized development settings, the `Makefiles` optionally include `.env` file (excluded from git) if it is present in the MCU directory. Note that the `.env` file is interpreted as a Makefile, therefore it must follow Makefile syntax. It is useful to override default settings or provide required settings that don't change much to avoid having to provide them on the command line on each invocation. An `.env` file could look as follows:
```
# MODEM is required by `make shell` and directs amforth-shell.py to connect to the specified TTY
MODEM ?= /dev/cu.usbmodemXXX
# If you want to override the toolchain to use for Amforth build,
# TC_DIR and CROSS are variables that control that
TC_DIR = $(AMFORTH)/toolchain/riscv-none-elf-15.2.0-1
CROSS = riscv-none-elf-
# amforth-shell.py uses the EDITOR variable when it attempts to open an external editor
export EDITOR=code
```
The Makefiles set most variables with `?=`, therefore most can be overridden by the `.env` file. Read the Makefile comments for more details. The Makefiles provide `AMFORTH` variable as a convenient way to refer to the directory where the AmForth repository was cloned.


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
* `make shell` - to connect `amforth-shell.py` to the board (`MODEM` variable needs to point at the board's serial device)

You can use any terminal emulator to connect to AmForth, but it is highly recommended to use `amforth-shell.py` because it provides a number of AmForth
specific highly useful conveniences that will be lacking with other emulators.

`amforth-shell.py` requires Python3 and the `pyserial` package. Python3 is often pre-installed by the host OS. If it isn't follow the recommended installation approach for your OS. The `pyserial` package usually needs to be installed with `pip3 install pyserial` command. If this gives you `error: externally-managed-environment`, and you don't want to heed its warnings and deal with Python virtual environments, then `pip3 install --user --break-system-packages pyserial` should be a relatively safe work-around.

#### QEMU

AmForth provides a number of emulated build targets. With these you do not upload AmForth binary file, instead you execute the `amforth.elf` file with the corresponding variant of the QEMU emulator. Use the recommended installation path for your OS to install QEMU. For ARM you will need `qemu-system-arm`, for RISC-V you will need `qemu-system-riscv32`.

There are several ways to run AmForth under QEMU, the `Makefiles` usually provide following options.
* `make stdio` - starts AmForth connected directly to the stdio of the terminal running the command; you don't need a terminal emulator in this case, but you only get very basic interaction capabilities
* `make pty` - starts AmForth connected to a PTY device (very much like when it's running on a physical board); the terminal stdio is connected to the QEMU monitor allowing control of the emulation process; QEMU will output the name of the PTY device on startup, set the `MODEM` variable to that and start `amforth-shell.py` with `make shell`

Finally the Linux based targets (e.g. `arm/mcu/linux`) can run on `qemu-user` on Linux or in Docker on other operating systems.

### Debugging

Debugging requires different tools based on what part of AmForth you want to debug. To debug CODEWORDs, or in situations where AmForth is generally not responsive (e.g. boot time and initialization issues) you will need an external debugger like GDB. External debugger is less convenient for debugging COLON words. This is because ITC is not directly executed, the CPU never jumps into the PFA area of a word, so you cannot just put a breakpoint there. For these situations AmForth also provides an internal debugger, which is the most convenient way to debug COLON words.

There are other AmForth or general Forth debugging techniques that can be useful in some circumstances. See [AmForth Programming and Debugging](https://amforth.sourceforge.net/TG/recipes/Programming.html) for a list of such techniques.

#### AmForth Debugger

When enabled, the AmForth debugger is engaged when execution reaches the word the word `break`. It causes the interpreter to be interrupted in the following cycle (before executing next word) and the debugger takes over. The debugger sends debugging information back to the terminal emulator (the data stack, backtrace and a short list of XTs to be executed next) and then waits for input from the operator. 

Debugger interprets user input as follows:
* `c`  - continue, resume normal execution (until `break` is hit again)
* `s` - step, executes single interpreter cycle and stops again, allows diving deeper into words being called
* `n` - next, steps through the current word without diving down into called words
* `r` - return, steps until the current word is fully executed and returns to the calling word
* any other input is evaluated as a Forth expression and the result is returned

`debug.break` is sort of a defer for the word implementing the debugger (but a user variable instead). It can be used to disable the debugger by setting it to 0. Words `debug+` and `debug-` do just that to enable or disable the debugger. When disabled the `break` word acts as a `nop`.

`amforth-shell` was extended to augment the presentation of the state sent by the debugger. It also loads symbols from the symbol table file and uses those to re-interpret raw addresses from the debugger; this allows interpreting NONAME word addresses (e.g. the `XT_R_WORD_INTERPRET` in the example below) and also addresses from other memory regions (e.g. `RAM_upper_datastack` below).

Below is a transcript of a short debugging session using `fib` word that has a break at the top of it, so it will halt on each entry into the word (including the recursive calls):

```
: fib 
    break
    dup 2 <= if drop 1 exit then 
    dup 1- recurse swap 1- 1- recurse +
;
```

The stacks are presented each on its own line, with the stack label and current depth, e.g. `PS(3):`, `RS(10): `, followed by the list of top 10 values. If there are more than 10 values the list is finished with `...`. The stack lines are followed by a vertical dump of the ITC at the current IP position; one line per cell showing the IP address, the value it contains, and if it's an XT the name of its corresponding word. The `<<(IP)<<` marker shows what is the next XT to be executed.

The first (c)ontinue command in the example stops again because `break` is hit again on recursive call to `fib`. Next command shows the integrated debug-shell allowing evaluation of arbitrary forth expressions, useful to interrogate the current state of the runtime. The (r)eturn calls step until the execution pops out of the current word. The last (c)ontinue call doesn't hit another `break` and normal outer interpreter interaction resumes (the fib result is printed).

Note that the prompt changes to `#` instead of `>` when the debugger is in control instead of the interpreter.

```
> 5 fib .
PS(1): 5
RS(9): fib+2 XT_R_WORD_INTERPRET+3 interpret+14 catch+10 0 RAM_upper_datastack-8 quit+18 warm+20 0
400428D4 400002A8 dup   <<(IP)<<
400428D8 40001D30 2
400428DC 40000730 <=
400428E0 400010EC (?branch)
400428E4 400428F4
# c
PS(2): 4 5
RS(10): fib+2 fib+13 XT_R_WORD_INTERPRET+3 interpret+14 catch+10 0 RAM_upper_datastack-8 quit+18 warm+20 0
400428D4 400002A8 dup   <<(IP)<<
400428D8 40001D30 2
400428DC 40000730 <=
400428E0 400010EC (?branch)
400428E4 400428F4
# 3 4 + .
7  ok
# r
PS(2): 3 5
RS(9): fib+13 XT_R_WORD_INTERPRET+3 interpret+14 catch+10 0 RAM_upper_datastack-8 quit+18 warm+20 0
40042900 400000CC swap   <<(IP)<<
40042904 40000DC4 1-
40042908 40000DC4 1-
4004290C 400428CC fib
40042910 40000118 +
# r
PS(1): 5
RS(8): XT_R_WORD_INTERPRET+3 interpret+14 catch+10 0 RAM_upper_datastack-8 quit+18 warm+20 0
400019B0 4000025C (exit)   <<(IP)<<
400019B4 00000003
400019B8 40000635
400019BC 400006F8 0<
400019C0 400010EC (?branch)
# c
5  ok
>
```

Same scenario using a generic terminal emulator (not amforth-shell) shows the raw debug info lines that are sent from AmForth. The `|D ` prefix is used to indicate that the line contains information produced from the debugger. The debugging commands and the debug-shell expressions work the same way.

```
> 5 fib .
|D PS: 1  5 
|D RS: fib+2 400019A4+3 interpret+14 catch+10 0 4004059C quit+18 warm+20 0 
|D 400428D4 400002A8 dup   <<(IP)<<
|D 400428D8 40001D30 2
|D 400428DC 40000730 <=
|D 400428E0 400010EC (?branch)
|D 400428E4 400428F4 
 ok
# c
|D PS: 2  4 5 
|D RS: fib+2 fib+13 400019A4+3 interpret+14 catch+10 0 4004059C quit+18 warm+20 0 
|D 400428D4 400002A8 dup   <<(IP)<<
|D 400428D8 40001D30 2
|D 400428DC 40000730 <=
|D 400428E0 400010EC (?branch)
|D 400428E4 400428F4 
 ok
# 3 4 + .
|D 7  ok
# r
|D PS: 2  3 5 
|D RS: fib+13 400019A4+3 interpret+14 catch+10 0 4004059C quit+18 warm+20 0 
|D 40042900 400000CC swap   <<(IP)<<
|D 40042904 40000DC4 1-
|D 40042908 40000DC4 1-
|D 4004290C 400428CC fib
|D 40042910 40000118 +
 ok
# r
|D PS: 1  5 
|D RS: 400019A4+3 interpret+14 catch+10 0 4004059C quit+18 warm+20 0 
|D 400019B0 4000025C (exit)   <<(IP)<<
|D 400019B4 00000003 
|D 400019B8 40000635 
|D 400019BC 400006F8 0<
|D 400019C0 400010EC (?branch)
 ok
# c
5  ok
> 
```

Debugger support requires modifying the inner interpreter to allow interrupting the normal COLON word interpretation cycle after each word. This is achieved by designating a register as a `DEBUG` register (ARM: r6, RV: s7) and checking in each cycle if its value is 0. If not the register indicates the currently running debug action that is interpreted by the debugger. This adds overhead of a single test and jump instruction to the normal interpreter cycle (see {arm|rv}/interpret.s). All other overhead is incurred only when the debugger is activated. AmForth can be rebuilt with `WANT_DEBUGGER` set to `NO` to eliminate all debugger overhead (including code).

#### GDB

GDB should be primarily used for debugging CODEWORDs or in situations where AmForth is generally not responsive (e.g. boot time and initialization issues). AmForth runtime is a completely alien environment for GDB, that is why AmForth development tooling provides GDB extensions to give better insight into the state of AmForth virtual machine. The Makefiles normally provide `make gdb` command that starts the maximally extended GDB connected to the current target (more on that below). The extensions are implemented equally for both CPU architectures.

To debug AmForth GDB must connect to it through a "GDB server" process. This is somewhat different between [emulated](#qemu-targets) and [physical](#physical-targets) targets as discussed below.

GDB is normally part of the GNU toolchain. There are two variants of GDB and two fundamental ways of extending it.

Basic GDB allows adding custom commands implemented in terms of pre-existing GDB commands. AmForth dev tooling uses `.gdb` files for extending basic GDB this way. The main extension file is `amforth.gdb` and is specific to each CPU architecture, so there is `arm/dev/amforth.gdb` and `rv/dev/amforth.gdb`. The shared commands are in `core/dev/amforth-core.gdb` and are included automatically in the former files. These extensions provide commands to dump the parameter (`.s`) or return (`.r`) stack, commands to inspect dictionary words (`.lfa`, `.ffa`, `.nfa`, `.cfa`, ...), and debugging helpers for setting breakpoints etc. See the file comments for more details.

Another category of extensions is the GDB TUI (text UI). It allows creating a more informative interface layout that shows more information at a glance. The layout is composed of predefined "windows". File `core/dev/tui-basic.gdb` provides such layout using the basic predefined windows. It includes a view of all  CPU registers, view of the disassembled code being executed, and the original source of that code (when possible, see [Code source](#code-source) below).

#### GDBPY

A separate GDB executable (usually with a `py` suffix) extends the basic GDB with a Python API that allows much more extensive customization. This one may take a bit of fiddling to get going because it relies on Python3 being installed on the host OS as a shared library. It is fussy about specific version being available, etc. You may need to pay close attention to the error messages to resolve these issues if it fails to start.

It is however worth it, if you can get it going, because the extensions are much more powerful when using GDBPY. In general you get a much more capable TUI with an additional window for the AmForth data stack and return stack. It also extends the register window to highlight which registers are dedicated for the Forth runtime and renders their value in most suitable way. Moreover a custom ForthUnwinder allows GDB to properly reconstruct the AmForth backtrace, so the core GDB `bt` command becomes actually usable.

These extensions are brought in by the `core/dev/tui-full.gdb` file. This is what is used by the `make gdb` command by default. If you cannot get GDBPY to work correctly then change it to use the `tui-basic.gdb` and basic GDB instead.

#### Code source

Both TUI versions employ a source window that tries to map the executed instructions to the original source code that produced it. For this `amforth.elf` must be compiled with debug information, which it is by default (assembler -g option). However the GNU assembler only produces debug info for actual assembler code. This means that you will see correct source when debugging a CODEWORD, but a completely incorrect source when stepping through a COLON word.

The only way to correct this situation is to instrument the build process to generate detailed debug information for all files in some other way. This has not been done (yet), partly because it cannot be done only partially. As soon as the assembler sees any explicit debug information in the sources it is compiling, it stops automatically generating any debug info at all. So we either have to explicitly instrument everything, or nothing at all; therefore it's the latter at the moment.

Moreover all the pre-compiled AmForth words are marked as proper function blocks for debug_info purposes. This however proved to be insufficient to resolve the source mapping issues.

#### QEMU targets

Emulated targets can rely on QEMU's built in GDB server for GDB connection. All that's needed is starting QEMU with the `-s` option. The `make debug` command does exactly that. The GDB server runs with the default TCP port 1234. This is where `make gdb` will try to connect to for these targets.

If you need to debug AmForth's early boot sequence, it is often useful to add the `-S` option that will instruct QEMU to start AmForth in a halted state, this way it will wait for GDB to connect and you will have full control over what happens next.

#### Physical targets

Physical targets require an external GDB server that is capable of relaying GDB commands to the MCU through MCU's debugging instrumentation. This is what `OpenOCD` does. As you can imagine this is a fairly complex and highly MCU specific setup. Consequently MCUs often require a customized version of OpenOCD, often provided by the MCU vendor. This makes it difficult to provide universal instructions on how to install OpenOCD, you will need to find instructions specific to the MCU you are interested in. The MCU readme may have additional information on this. Sometimes it may be easiest to install a development environment recommended for the board in question (e.g. Arduino IDE) and find the OpenOCD installation there. You should be able to easily hook the AmForth make commands to that installation through the `OPENOCD` make variable.

Once you have OpenOCD installed, `make ocd` command is set up to start and connect OpenOCD to the specific MCU target. When you have OpenOCD running, the `make gdb` command will start and connect GDB to it. You will commonly need separate terminal windows to control all these components. That includes another terminal to run `amforth-shell.py` to interact with AmForth itself.

### Uploaders

Uploaders are another class of highly MCU specific tools. There are no general installation instructions to offer here either. Again the best route may be installing the recommended development environment for the board in question and finding what it is using. The MCU Makefile or readme may have some pointers. The `make upload` command can be used to upload AmForth binary file to the board, once the correct uploader is installed. The MCU Makefile should have instructions on how to connect the uploader installation to the make command.

### Other MCU tools

There may be other MCU specific commands available. The MCU Makefile should have all the information about these.

## Testing

Testing on physical boards is currently a manual process. There isn't any automation available for that at this time.

However AmForth does have a suite of tests that can run on emulated targets easily. This test suite is based on the standard Forth testing framework and includes the standard Forth test suite as well. The test suite files are in `$(AMFORTH)/tests` directory. 

To run the test suite, the target has to be built with `WANT_IGNORECASE` option set. This is because the standard test suite
is written in all-caps and AmForth words are all in lowercase. This option allows words to match regardless of the case.

The `make tests` command runs the full test suite assuming a QEMU target compiled with `WANT_IGNORECASE`. For example, to run
the test suite on the `arm/mcu/qemu` target, following steps would be used.
* `WANT_IGNORECASE=1 make all`
* `make tests`

The command analyses the output of the test run and summarizes the test results. An `awk` script is used to parse the test output. Awk is usually preinstalled on the host OS, if not use the OS package manager to install it.

Any test failures will be emitted in the output showing the test that failed and the incorrect output it produced. The command emits a final test summary showing the number of tests passed and failed and whether the whole suite completed. Summary of a successful test run looks like this
```
qemu-system-arm: terminating on signal 15 from pid 17281 (<unknown process>)
FINISHED: Y, PASS: 635, FAIL: 0
```

The termination warning is there because the test command must kill the QEMU process at the end, otherwise it would not quit. The test command gives the QEMU process predefined amount of time (e.g. 5 seconds) to run through the test suite and then kills it. It detects from the test output whether the whole test suite ran in that time or not. The `timeout` command is used to control the QEMU process. This command is native on Linux, on other OSes install `coreutils` to get it.

AmForth CI runs the full test suite on every new commit pushed to GitHub. It runs it twice, once in normal build configuration and once with `WANT_ITC` set. When `WANT_ITC` option is set the build prefers the core/words ITC version of words over the native assembler version if both exist (normally it is the other way around). This makes sure both versions are exposed to the test suite in the CI tests. This whole process is also repeated for each CPU architecture. It uses the `QEMU -M virt` target for each.

## Transpiling

To add words to the core dictionary the word implementation must be converted into its compiled form, either native assembler for CODEWORDS or a sequence of words representing the body of a COLON word (called ITC assembler or just ITC). The words in `core/words` are examples of ITC assembler words and words in `arm/words` or `rv/words` are examples of native assembler words.

Writing ITC assembler by hand is cumbersome. Transpiling provides a way to convert word source in Forth into its ITC equivalent. The tooling for transpiling is split between amforth itself and amforth-shell. When transpiling is enabled (`tpile+/tpile-`) amforth emits tokens during compilation of a word back to the host. These tokens are relatively easy to convert to ITC assembler source, this is what amforth-shell does. Here's an example of the transpiling interaction between amforth and amforth-shell compiling word `fib` followed by the transpiled result emitted by amshell.

```
|S|    2|: fib 
|O|    2|WW666962 X400428D4 X40000681
|S|    3|    dup 2 > if 
|O|    3|X400002D4 X40001E98 X400007BC X400011C0 X00000000 F400428E8
|S|    4|       dup 1- recurse swap 1- 1- recurse + exit 
|O|    4|X400002D4 X40000E64 X400428D4 X400000D4 X40000E64 X40000E64 X400428D4 X40000128 X400002A4
|S|    5|    then 
|O|    5|L400428E8
|S|    6|    drop 1 
|O|    6|X40000098 X40001E84
|S|    7|;
|O|    7|X40000288 END

# : fib
COLON "fib", FIB
    # dup 2 > if
    .word XT_DUP, XT_TWO, XT_GREATER, XT_DOCONDBRANCH, 1f
       # dup 1- recurse swap 1- 1- recurse + exit
       .word XT_DUP, XT_1MINUS, XT_FIB, XT_SWAP, XT_1MINUS, XT_1MINUS, XT_FIB, XT_PLUS, XT_FINISH
    # then
1:     # drop 1
    .word XT_DROP, XT_ONE
   # ;
   .word XT_EXIT
END FIB
```

To trigger transpiling, use the `#transpile` directive (instead of `#include` directive) to load a Forth source file. Amforth-shell will attempt to transpile all word definitions in the file. If the words compile successfully the transpiled ITC should also be correct. Note however that the words being transpiled can only use core words or words previously transpiled in the same amforth-shell session (e.g. words preceding in the same file). Recursive calls should also transpile correctly. It is therefore important to review the transpiled results for correctness.

Amforth-shell must have an up to date symbol table matching the compiled amforth binary. This is needed to translate raw addresses to the corresponding `XT` symbols. The symbol table is normally included as file named `amforth.sym` and should be located in the current working directory. Option `--sym-file` allows pointing amforth-shell at a different file instead.

Amforth-shell emits the ITC along with the original Forth line (as a comment). It follows the offsets of the original source lines to offset the ITC code. It collects the continuous block of comments before the word and emits it as a long description block comment after the ITC word header. Similarly it parses the line that starts the word definition to look for stack signature and following short description to emit with the ITC header (to be used in the reference card tables).

The transpiler support can be compiled in or out of amforth with WANT_TRANSPILER config option. Amforth-shell will report an error if #transpile is used without transpiler being available on the target.
