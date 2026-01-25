# Put configuration variables specific to your local development environment into .env file in this directory.
# (it will be ignored by git, and won't be committed to the repository)
#
# Following variables should be set there:
# * MODEM - the serial device used to connect to the board, e.g cu.usbmodemB43A45B4700C2
# * BOSSAC - UNO R4 uploader (see more details below)
# * OPENOCD - on-chip debugging server for GDB
#
# If you have Arduino IDE installed with the Uno R4 board you can
# point BOSSAC, OPENOCD at the Arduino installed binaries, e.g.
# ARDUINO_TOOLS = /Users/martin/Library/Arduino15/packages/arduino/tools
# BOSSAC=$(ARDUINO_TOOLS)/bossac/1.9.1-arduino5/bossac
# OPENOCD = $(ARDUINO_TOOLS)/openocd/0.11.0-arduino2/bin/openocd
-include .env

MCU_LD ?= ra4m1.ld

LANG=C
BOARD = UNOR4
# serial connection speed used by AmForth and the UNO R4 bootloader
SPEED = 115200

AMFORTH ?= $(shell git rev-parse --show-toplevel)

# Included after various configuration bits are defined (importantly MCU_LD)
include $(AMFORTH)/arm/dev/Makefile

# Using bossac as the uploader, based on what Arduino IDE uses to program the board.
# https://www.shumatech.com/web/products/bossa
# https://github.com/arduino/BOSSA
BOSSAC ?= bossac
OPENOCD ?= openocd

# N.B.: The UNO R4 BOSSA_LOADER always stores the file at FLASH_IMAGE_START (+offset),
# 		so DO NOT use -o to enforce FLASH_IMAGE_START!
# see https://github.com/arduino/arduino-renesas-bootloader/blob/main/src/bossa.c#L272
# see also ./memmap.ld
#
# The board must be in bootloader mode for bossac to be able to communicate with it.
# The LED soft pulses at 1 sec intervals when in bootloader mode.
# To put the board into bootloader mode manually, press and release the RESET button twice.
# Alternatively the touch1200bps utility can achieve the same as well.
#
# Note: it seems only the Arduino version of bossac works with UNO R4 (https://github.com/arduino/BOSSA)
upload: build/amforth.bin touch1200bps
	touch1200bps/touch1200bps /dev/$(MODEM)
	$(BOSSAC) --debug --port=$(MODEM) --write build/amforth.bin --reset

# This builds the touch1200bps binary; requires a reasonably recent version of Golang installed.
# This is used above for the upload target.
touch1200bps: touch1200bps/*
	cd ./touch1200bps && go build

.PHONY: clean upload touch1200bps ocd gdb

## Start OpenOCD
# You can connect to the OpenOCD telnet port with: nc localhost 50002
# You can also send commands to OpenOCD through GDB's 'monitor' command
# ocd: build/amforth.elf
ocd:
	$(OPENOCD) -c "gdb_port 50000" -c "tcl_port 50001" -c "telnet_port 50002" \
		-c "adapter driver cmsis-dap" \
		-c "transport select swd" \
		-f dev/R7FA4M1AB.cfg

## Start gdb and connect to OpenOCD
# If you don't have/want python enabled GDB you can
# * replace $(GDBPY) with $(GDB)
# * replace tui-full.gdb with tui-basic.gdb
# gdb: build/amforth.elf
gdb:
	$(GDBPY) -tui build/amforth.elf --quiet \
		-ex "target extended-remote localhost:50000" \
		-ex "directory ../../dev" \
		-ex "source tui-full.gdb"

# More debugging references
# https://undo.io/resources/guide-to-symbols-debug-info/

GOBUILD = cd ./touch1200bps && go build -o dist/ .
TAR = cd touch1200bps/dist && tar zcf
dist1200bps:
	export GOOS=darwin GOARCH=arm64; $(GOBUILD)
	$(TAR) touch1200bps-osx-arm64.tgz touch1200bps
	export GOOS=darwin GOARCH=amd64; $(GOBUILD)
	$(TAR) touch1200bps-osx-amd64.tgz touch1200bps
	export GOOS=linux GOARCH=arm64; $(GOBUILD)
	$(TAR) touch1200bps-linux-arm64.tgz touch1200bps
	export GOOS=linux GOARCH=amd64; $(GOBUILD)
	$(TAR) touch1200bps-linux-amd64.tgz touch1200bps
	export GOOS=windows GOARCH=amd64; $(GOBUILD)
	$(TAR) touch1200bps-windows-amd64.tgz touch1200bps.exe