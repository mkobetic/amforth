# Generic make targets for building amforth in a unified way.
# Requirements:
# 1) toolchain was installed (see make toolchain in {rv|arm}/dev/Makefile)
# 2) {arm|rv}/dev/Makefile was included (to set CROSS, TC_DIR,...)
# 3) MCU_LD must be set to the name of the MCU linker script
#	e.g. MCU_LD = stellaris.ld
#
# Included through {arm|rv}/dev/Makefile

AMFORTH ?= $(shell git rev-parse --show-toplevel)

REVISION := $(shell git status -bs -u no|tr / -)
ifeq ("$(REVISION)", "")
    REVISION := $(shell svnversion -n)
endif

# These are implicit variables in make, can't use ?=
# see https://www.gnu.org/software/make/manual/html_node/Implicit-Variables.html
AS := $(TC_DIR)/bin/$(CROSS)as
LD := $(TC_DIR)/bin/$(CROSS)ld
CC := $(TC_DIR)/bin/$(CROSS)gcc
CXX := $(TC_DIR)/bin/$(CROSS)g++
CPP := $(TC_DIR)/bin/$(CROSS)cpp

# Tools that can be overridden by the environment
PP ?= $(CPP) # to allow overriding the pre-processor (use PP instead of CPP)
OBJCOPY ?= $(TC_DIR)/bin/$(CROSS)objcopy
OBJDUMP ?= $(TC_DIR)/bin/$(CROSS)objdump
READELF ?= $(TC_DIR)/bin/$(CROSS)readelf
RANLIB ?= $(TC_DIR)/bin/$(CROSS)ranlib
NM ?= $(TC_DIR)/bin/$(CROSS)nm
SIZE ?= $(TC_DIR)/bin/$(CROSS)size

# Debugging tools
GDB ?= $(TC_DIR)/bin/$(CROSS)gdb
GDBPY ?= $(TC_DIR)/bin/$(CROSS)gdb-py3

## Build all files
all: build/amforth.bin build/amforth.hex build/amforth.lst

buildinfo: words/build-info.tmpl
	cat words/build-info.tmpl | sed "s/%d/ `date`/" | sed "s/%r/${REVISION}/" > words/build-info.s
	mkdir -p build

ASFLAGS := -g --warn --fatal-warnings -ahlmn=build/amforth.lst-as
# if you want to run standard tests you need WANT_IGNORECASE flag set
ifdef WANT_IGNORECASE
ASFLAGS +=--defsym WANT_IGNORECASE=$(WANT_IGNORECASE)
endif

# Needed for the INCLUDE amforth32.ld to work in linked files (-L must precede the -T !!!)
LDFLAGS := -L $(AMFORTH)/core -T $(MCU_LD)

# The include order is important: architecture > core > AMFORTH
# for simple imports, e.g. config.inc or words/xx.s, the more specific directory wins
# the AMFORTH root allows include files to import more general include files with the same name
INCLUDES := -I../.. -I $(AMFORTH)/core -I $(AMFORTH)
build/%.o: %.s buildinfo
	$(AS) $(ASFLAGS) $(INCLUDES) -o $@ $<

# Sometimes make decides that amforth.elf is an intermediary file that should be deleted.
.PRECIOUS: build/amforth.elf

build/%.elf: build/%.o
	$(LD) $(LDFLAGS) $< -o $@ 

build/%.hex: build/%.elf
	$(OBJCOPY) -O ihex $< $@

build/%.bin: build/%.elf
	$(OBJCOPY) -O binary $< $@

build/%.lst: build/%.elf
	$(OBJDUMP) --show-raw-insn --insn-width=4 --all-headers --disassemble-all --source --syms $< >$@

clean:
	rm -f build/* words/build-info.s

SPEED ?= 115200
AMSHELL=$(AMFORTH)/tools/amforth-shell.py --port $(MODEM) --speed $(SPEED) $1
export AMFORTH_LIB=.:$(AMFORTH)/tests:$(AMFORTH)/lib
## Connect via AmShell
# export EDITOR in your .env file to make the #edit shell directive work.
shell:
	$(AMSHELL) --no-error-on-output -i

## Run standard tests, output failures and summarize the results.
# Not finished means we didn't get through the whole test file.
# Requires WANT_IGNORECASE, because the standard tests
# are in all caps and all AmForth words are in lowercase;
# `WANT_IGNORECASE=1 make` should do it.
# Uses timeout command to terminate QEMU, because there is no way
# to do it from the inside, i.e. from AmForth running in it.
TIMEOUT ?= 2s
TESTER ?= $(AMFORTH)/lib/forth2012/tester/tester-amforth.frt
ifdef RAW
RESULTS := cat
else
RESULTS := awk -f $(AMFORTH)/tests/results.awk
endif
test:
	{ cat $(TESTER); \
	  echo '.s" TESTS STARTING"' ; \
	  $(PP) -w $(AMFORTH)/tests/cpp-core.fr; \
	  cat $(AMFORTH)/tests/core2.fr; \
	  echo '.s" TESTS FINISHED"' ; \
	} | timeout -s TERM $(TIMEOUT) $(QEMU) -serial stdio | \
	$(RESULTS)

## A detailed dump of ELF sections for debugging linker issues
sections: sec-type sec-addr sec-sum

sec-type:
	# SECTION TYPES:
	# Type:
	# 	PROGBITS: Program data (code, initialized constants).
	#	NOBITS: Occupies no space in the file (e.g., .bss, NOLOAD).
	#	SYMTAB / STRTAB: Symbol tables and string tables for debugging.
	# Flags:
	#	W (write): The processor is allowed to write to this memory address (RAM).
	#	A (alloc): This section is "allocated"—it exists in the memory map of the device at runtime.
	#	X (execute): This section contains code that the CPU can run.
	#	M (merge): The linker may merge duplicate data to save space (common in strings).
	#	S (strings): The section contains null-terminated strings.
	# ES - entry size for table sections (fixed sized elements)
	# Lk - index number of a linked section (relocations, symbol tables)
	# Inf - extra info (relo & symtables)
	# Al - section Addr alignment in bytes (must be 2^n)
	$(READELF) --sections build/amforth.elf

sec-addr:
	# SECTION ADDRESSES:
	# Flags: Name | Description [ Linker Script / ELF Equivalent ]
	# 	CONTENTS	The section has actual data stored in the file. [ SHT_PROGBITS ]
	#	ALLOC		Space must be reserved for this section in RAM/Flash at runtime. [ SHF_ALLOC (the A flag) ]
	#	LOAD		This section should be loaded into memory from the file. [ Not NOLOAD ]
	#	READONLY	The section cannot be modified at runtime (usually in Flash). [ Missing SHF_WRITE ]
	# 	CODE		Contains executable CPU instructions.	[ .text ]
	#	DATA		Contains initialized variables or constants.	[ .data, .rodata ]
	#	DEBUGGING	Contains DWARF or stabs info for GDB (not loaded).	[ .debug_info ]
	#	HAS_CONTENTS	Similar to CONTENTS; implies the section isn't empty.	[ Various ]
	$(OBJDUMP) -h build/amforth.elf

sec-sum:
	# SECTION SIZE SUMMARY:
	$(SIZE) build/amforth.elf
	$(SIZE) build/amforth.elf

## Dump symbols sorted by address, optionally filtered by section (e.g. sec=amramlo)
symbols:
	# Value Flags[7] Section Size Symbol
	# Flags[0]: (l,g,,!) local, global, neither, both.
	# Flags[1]: (w,) weak or strong symbol.
	# Flags[2]: (C,) symbol denotes a constructor or an ordinary symbol.
	# Flags[3]: (W,) symbol is warning or normal symbol.
	# Flags[4]: (I,) indirect reference to another symbol or normal symbol.
	# Flags[5]: (d,D,) debugging symbol, dynamic symbol or normal symbol.
	# Flags[6]: (F,f,O,) symbol is the name of function, file, object or normal symbol.
	@$(OBJDUMP) --syms build/amforth.elf $(if $(sec), | grep $(sec),) | \
		grep -E '^[0-9a-f]{8} .*' | \
		awk '{ printf "0x%s\n",$$0; }' | \
		sort --key=1 --sort=numeric
