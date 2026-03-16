# SPDX-License-Identifier: GPL-3.0-only
# AmForth-RV Makefile

-include .env

AMFORTH ?= $(shell git rev-parse --show-toplevel)

QEMU_RV32 ?= qemu-system-riscv32
WLINK ?= $(HOME)/.cargo/bin/wlink
MINICOM ?= minicom

SOCKSHELL=$(AMFORTH)/tools/socket-shell.py --port $(MODEM) --speed 115200 $1
UU=$(AMFORTH)/tools/uu

# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
# Guessing variables based on operating system

# Default target to build
TARGET ?= 307
TARGETS = 307 305 203 

CHIPSET=$(TARGET)
MCU_LD := ./$(TARGET).ld
LIB_WCH := ./lib_$(TARGET)
LIB_USER := ./lib_$(TARGET)_user

# Included after various configuration bits are defined (importantly MCU_LD and TARGET)
include $(AMFORTH)/rv/dev/Makefile


.PHONY: info shell speed save uu 

## Upload hex file to the device  
upload:
	$(WLINK) flash build/amforth.hex

## Connect via USB 
uu:
	$(UU) 

## Connect via minicom 
min:
	$(RM) minicom.cap
	$(MINICOM) -D $(MODEM) --color=on -C minicom.cap


#? --- QEM ---
QEMU := $(QEMU_RV32) -M virt -bios none -kernel $(BUILD_DIR)/$(TARGET_ELF)

## Start AmForth under QEMU with operator uart connected to stdio
stdio:
	$(QEMU) -display none -serial stdio

## Start AmForth under QEMU with operator uart connected to a pty
pty:
	$(QEMU) -nographic -serial pty

# Add -S if you want QEMU to not start the quest.
## Like pty but allows GDB to attach to it (-s).
debug:
	$(QEMU) -nographic -serial pty -s

## Start AmForth under QEMU with operator uart connected to a socket
sock:
	$(QEMU) -nographic -serial tcp:localhost:4321,server,nowait  # need to terminate

## Start sock shell  
sksh:
	$(SOCKSHELL) --no-error-on-output -i 

#? --- Debugging ---
## Start GDB 
#gdb:
#	$(BIN_STUB)-gdb --ex 'target extended-remote :3333' $(BUILD_DIR)/$(TARGET_ELF)

## Connect GDB to amforth running on QEMU (must be running with -s, see debug)
gdb:
	$(GDBPY) build/amforth.elf --quiet \
		-ex 'target remote :1234' \
		-ex "source tui-full.gdb"

## Start OpenOCD
ocd:
	$(OPENOCD) -f $(OPENCFG)
