
TARGET ?= QEM
TARGETS = QEM
MCU_LD ?= qemu.ld
ifneq ($(strip $(TARGET)), QEM)
$(error Unknown TARGET '$(TARGET)')
endif

LANG=C
AMFORTH ?= $(shell git rev-parse --show-toplevel)

# Included after various configuration bits are defined (importantly MCU_LD)
include $(AMFORTH)/arm/dev/Makefile

QEMU := qemu-system-arm -M virt -cpu cortex-a15 -display none -kernel build/amforth.elf
## Start AmForth under QEMU with operator uart connected to a pty
stdio:
	$(QEMU) -serial stdio

# Use this when you want more powerful terminal emulator than the very basic stdio.
# The pty device is printed after start, connect to it with a terminal emulator,
# e.g.: tio --map=ODELBS /dev/ttys019	// ODELBS fixes backspace behavior
## Start AmForth under QEMU with operator uart connected to a pty
pty:
	$(QEMU) -serial pty
#	Following was an attempt to predefine the device filename
#	Unsuccessful so far: Failed to create PTY symlink: Operation not permitted
#	$(QEMU) -chardev pty,path=/dev/stellaris,id=stellaris -serial chardev:stellaris

# Add -S if you want QEMU to not start the quest.
# WARNING: GDB TUI struggles to start properly when the target has not started (-S).
## Like pty but allows GDB to attach to it (-s).
debug:
	$(QEMU) -serial pty -s

## Connect GDB to running amforth (must be running with -s, see debug)
gdb:
	$(CROSS)gdb-py build/amforth.elf --quiet \
		-ex 'target remote :1234' \
 		-ex "directory ../../dev" \
		-ex "source tui-full.gdb"
