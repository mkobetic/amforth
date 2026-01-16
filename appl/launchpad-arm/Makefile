
REVISION := $(shell git status -bs -u no|tr / -)
ifeq ("$(REVISION)", "")
    REVISION := $(shell svnversion -n)
endif

CROSS=arm-none-eabi-
BOARD=$(shell uname -m)
ifeq ("$(BOARD)", "armv7l")
   CROSS=
endif
LANG=C

all: build/amforth.hex build/amforth.lst

buildinfo: words/build-info.tmpl
	cat words/build-info.tmpl | sed "s/%d/ `date`/" | sed "s/%r/${REVISION}/" > words/build-info.s

build/%.o: %.s buildinfo
	$(CROSS)as -g --warn --fatal-warnings -alms=build/amforth.lst-as -I../../arm -I ../../arm/devices/lm4f120xl -I ../../shared -o $@ $<


build/amforth.elf: build/amforth.o
	$(CROSS)ld -L ../../shared -T launchpad.ld $< -o $@ 
	$(CROSS)objcopy build/amforth.elf build/amforth.bin -O binary

build/%.hex: build/%.elf
	$(CROSS)objcopy -O ihex $< $@

build/%.lst: build/%.elf
	$(CROSS)objdump --show-raw-insn --insn-width=4 --all-headers --disassemble-all --source --syms $< >$@

sections:
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
	#
	$(CROSS)readelf --sections build/amforth.elf
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
	$(CROSS)objdump -h build/amforth.elf
	#
	# SECTION SIZE SUMMARY:
	$(CROSS)size build/amforth.elf

clean:
	rm -f build/* words/build-info.s

upload: build/amforth.elf
	lm4flash build/amforth.bin


# QEMU's lm3s6965evb machine is not the LM4F120H5QR (m3 vs m4), but seems to be close enough.
# https://www.qemu.org/docs/master/system/arm/stellaris.html
QEMU=qemu-system-arm -M lm3s6965evb -display none -bios none -kernel build/amforth.elf

# Starts amforth under QEMU
run:
	$(QEMU) -serial stdio

# Starts amforth under QEMU with serial port connected to a pty.
# Use this when you want more powerful terminal emulator than the very basic stdio.
# The pty device is printed after start, connect to it with a terminal emulator,
# e.g.: tio --map=ODELBS /dev/ttys019	// ODELBS fixes backspace behavior
runpty:
	$(QEMU) -serial pty
#	Following was an attempt to predefine the device filename
#	Unsuccessful so far: Failed to create PTY symlink: Operation not permitted
#	$(QEMU) -chardev pty,path=/dev/stellaris,id=stellaris -serial chardev:stellaris

# Like prun but halts on start and waits for GDB to attach to it
debug:
	$(QEMU) -serial pty -S -s

# Connect GDB to running amforth (must be running with the -S -s flags!)
gdb:
	$(CROSS)gdb-py build/amforth.elf --quiet \
		-ex 'target remote :1234' \
 		-ex "directory ../../arm/dev"
