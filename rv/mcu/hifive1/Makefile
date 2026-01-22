AMFORTH ?= $(shell git rev-parse --show-toplevel)
include $(AMFORTH)/rv/dev/Makefile
MCU_LD ?= hifive1.ld


BOARD ?= freedom-e300-hifive1
COPTS += -Wall  -Os -nostdlib -nostartfiles -ffreestanding -save-temps
AOPTS = --warn --fatal-warnings


#############################################################
# This Section is for uploading a program to SPI Flash
#############################################################
GDB_PORT ?= 3333

RISCV_OPENOCD = openocd
OPENOCDCFG = ./openocd.cfg
OPENOCDARGS += -f $(OPENOCDCFG)

GDB_UPLOAD_ARGS = --batch

GDB_UPLOAD_CMDS += -ex "set remotetimeout 240"
GDB_UPLOAD_CMDS += -ex "target extended-remote localhost:$(GDB_PORT)"
GDB_UPLOAD_CMDS += -ex "monitor reset halt"
GDB_UPLOAD_CMDS += -ex "monitor flash protect 0 64 last off"
GDB_UPLOAD_CMDS += -ex "load"
GDB_UPLOAD_CMDS += -ex "monitor resume"
GDB_UPLOAD_CMDS += -ex "monitor shutdown"
GDB_UPLOAD_CMDS += -ex "quit"

upload:
	$(RISCV_OPENOCD) $(OPENOCDARGS) & \
	$(GDB) build/amforth.hex $(GDB_UPLOAD_ARGS) $(GDB_UPLOAD_CMDS) && \
	echo "Successfully uploaded 'amforth.hex' to $(BOARD)."

# QEMU's SiFive E31 core machine should be close enough (according to AI).
# But doesn't really work.
QEMU=qemu-system-riscv32 -M sifive_e -display none -bios none -kernel build/amforth.elf

# Starts amforth under QEMU
run:
	$(QEMU) -serial stdio
