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

AS := $(TC_DIR)/bin/$(CROSS)as
LD := $(TC_DIR)/bin/$(CROSS)ld
OBJCOPY := $(TC_DIR)/bin/$(CROSS)objcopy
OBJDUMP := $(TC_DIR)/bin/$(CROSS)objdump
READELF := $(TC_DIR)/bin/$(CROSS)readelf
SIZE := $(TC_DIR)/bin/$(CROSS)size
GDB := $(TC_DIR)/bin/$(CROSS)gdb
GDBPY := $(TC_DIR)/bin/$(CROSS)gdb-py3

all: build/amforth.bin build/amforth.hex build/amforth.lst

buildinfo: words/build-info.tmpl
	cat words/build-info.tmpl | sed "s/%d/ `date`/" | sed "s/%r/${REVISION}/" > words/build-info.s
	mkdir -p build

build/%.o: %.s buildinfo
	$(AS) -g --warn --fatal-warnings -alms=build/amforth.lst-as -I../.. -I $(AMFORTH)/core -o $@ $<

build/%.elf: build/%.o
	$(LD) -L $(AMFORTH)/core -T $(MCU_LD) $< -o $@ 

build/%.hex: build/%.elf
	$(OBJCOPY) -O ihex $< $@

build/%.bin: build/%.elf
	$(OBJCOPY) -O binary $< $@

build/%.lst: build/%.elf
	$(OBJDUMP) --show-raw-insn --insn-width=4 --all-headers --disassemble-all --source --syms $< >$@

clean:
	rm -f build/* words/build-info.s

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