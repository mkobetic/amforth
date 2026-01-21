AMFORTH ?= $(shell git rev-parse --show-toplevel)
include $(AMFORTH)/arm/dev/Makefile
MCU_LD ?= stellaris.ld


BOARD=$(shell uname -m)
ifeq ("$(BOARD)", "armv7l")
   CROSS=
endif
LANG=C

# if you want to run standard tests you need WANT_IGNORECASE flag set
AOPTS+=--defsym WANT_IGNORECASE=1

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

# Like runpty but halts on start and waits for GDB to attach to it
debug:
	$(QEMU) -serial pty -S -s

# Connect GDB to running amforth (must be running with the -S -s flags!)
gdb:
	$(CROSS)gdb-py build/amforth.elf --quiet \
		-ex 'target remote :1234' \
 		-ex "directory ../../dev"

# Run standard tests and output the results, requires WANT_IGNORECASE enabled above
# because the standard tests are in all caps and all amforth words are in lowercase.
# Makes it almost through the core tests, freezes at
# > TESTING SOURCE >IN WORD
#  ok
# > 
#  ok
# > : GS1 S" SOURCE" 2DUP EVALUATE
# 3153 554F 4352  ?? -13 30 
# >        >R SWAP >R = R> R> = ;

TESTER := $(AMFORTH)/lib/forth2012/tester
test:
	cat $(TESTER)/tester-amforth.frt $(TESTER)/core.fr | \
	timeout -s TERM 5s $(QEMU) -serial stdio | \
	awk ' \
		BEGIN { pass = 0; fail = 0 } \
		/^> TESTING / { print } \
		/^> T\{.*\}T/ { marker=$$0; next } \
		marker && / ok[[:space:]]$$/ { pass += 1 } \
		marker && $$0 !~ / ok[[:space:]]$$/ { fail += 1 ; print marker; print $$0 } \
		{ marker="" } \
		END { \
			printf "PASS: %d, FAIL: %d, TOTAL: %d\n", pass, fail, pass + fail; \
			if (fail > 0) exit 1 \
		}'
