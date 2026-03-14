# SPDX-License-Identifier: GPL-3.0-only

-include .env

AMFORTH ?= $(shell git rev-parse --show-toplevel)

QEMU_RV32 ?= qemu-system-riscv32 

# Default target to build
TARGET = QEM
TARGETS = QEM
MCU_LD := ./qemu.ld
DIST_TARGET ?= rv-qemu-virt

# Included after various configuration bits are defined (importantly MCU_LD and TARGET)
include $(AMFORTH)/rv/dev/Makefile

.PRECIOUS: amforth.s


#? --- QEM ---
QEMU := $(QEMU_RV32) -M virt -bios none -kernel build/amforth.elf

## Start AmForth under QEMU with operator uart connected to stdio
stdio:
	$(QEMU) -display none -serial stdio

## Start AmForth under QEMU with operator uart connected to a pty
pty:
	$(QEMU) -nographic -serial pty

# Add -S if you want QEMU to not start the quest.
# WARNING: GDB TUI struggles to start properly when the target has not started (-S).
## Like pty but allows GDB to attach to it (-s).
debug:
	$(QEMU) -nographic -serial pty -s

## Start AmForth under QEMU with operator uart connected to a socket
sock:
	$(QEMU) -nographic -serial tcp:localhost:4321,server,nowait  # need to terminate

SOCKSHELL=$(AMFORTH)/tools/socket-shell.py --port $(MODEM) --speed 115200 $1

## Start sock shell  
sksh:
	$(SOCKSHELL) --no-error-on-output -i 

## Connect GDB to amforth running on QEMU (must be running with -s, see debug)
gdb:
	$(GDBPY) build/amforth.elf --quiet \
		-ex 'target remote :1234' \
		-ex "source tui-full.gdb"
