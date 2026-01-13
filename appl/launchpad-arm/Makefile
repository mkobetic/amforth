
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

build/%.o: %.asm buildinfo
	$(CROSS)as -g --warn --fatal-warnings -alms=build/amforth.lst-as -I../../arm -I ../../arm/devices/lm4f120xl -I ../../shared -o $@ $<


build/amforth.elf: build/amforth.o
	$(CROSS)ld -T memmap $< -o $@ 
	$(CROSS)objcopy build/amforth.elf build/amforth.bin -O binary

build/%.hex: build/%.elf
	$(CROSS)objcopy -O ihex $< $@

build/%.lst: build/%.elf
	$(CROSS)objdump -DSt $< >$@

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
prun:
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
 		-ex "directory ../../arm/dev" \
 		-ex "source .gdbinit"