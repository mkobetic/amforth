
REVISION := $(shell git status -bs -u no|tr / -)
CROSS=arm-none-eabi-
LANG=C
BOARD = UNOR4

# This port was developed on a MacBook with some tools borrowed from Arduino IDE.
# You will likely need to adjust PORT, BOSSAC and OPENOCD to suite your configuration.
ARDUINO_TOOLS = /Users/martin/Library/Arduino15/packages/arduino/tools

# USB device name to use for uploads
PORT=cu.usbmodemB43A45B4700C2
# Using bossac as the uploader, based on what Arduino IDE uses to program the board
# https://www.shumatech.com/web/products/bossa
# https://github.com/arduino/BOSSA
# BOSSAC = bossac
BOSSAC=$(ARDUINO_TOOLS)/bossac/1.9.1-arduino5/bossac
OPENOCD = $(ARDUINO_TOOLS)/openocd/0.11.0-arduino2


all: build/amforth.hex build/amforth.lst build/amforth.sym

buildinfo: 
	cat words/build-info.tmpl | sed "s/%d/ `date`/" | sed "s/%r/${REVISION}/" > words/build-info.s

build/%.o: %.s words/*.s buildinfo
	$(CROSS)as -g --warn --fatal-warnings -achlms=build/amforth.lst-as -I../../arm -I ../../arm/devices/cortex-m4 -I ../../shared -o $@ $<

build/amforth.elf: build/amforth.o
	$(CROSS)ld -T memmap.ld $< -o $@

build/%.lst: build/%.elf
	$(CROSS)objdump -DSt -j amforth $< >$@

build/%.sym: build/%.elf
	$(CROSS)nm -l $< >$@

build/%.hex: build/%.elf
	$(CROSS)objcopy -O ihex $< $@

build/%.bin: build/%.elf
	$(CROSS)objcopy -O binary $< $@


clean:
	rm build/* words/build-info.s

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
	touch1200bps/touch1200bps /dev/$(PORT)
	$(BOSSAC) --debug --port=$(PORT) --write build/amforth.bin --reset

# This builds the touch1200bps binary; requires a reasonably recent version of Golang installed.
# This is used above for the upload target.
touch1200bps: touch1200bps/*
	cd ./touch1200bps && go build

.PHONY: clean upload touch1200bps ocd gdb

# Start OpenOCD
# You can connect to the OpenOCD telnet port with: nc localhost 50002
# You can also send commands to OpenOCD through GDB's 'monitor' command
# ocd: build/amforth.elf
ocd:
	$(OPENOCD)/bin/openocd -c "gdb_port 50000" -c "tcl_port 50001" -c "telnet_port 50002" \
	-f $(OPENOCD)/share/openocd/scripts/interface/cmsis-dap.cfg \
	-f dev/select_swd.cfg \
	-f dev/R7FA4M1AB.cfg

# Start gdb and connect to OpenOCD
# Make sure .gdbinit is sourced to get additional commands and customized TUI
# If you don't have/want python enabled GDB you need to tweak .gdbinit and drop the -py below
# gdb: build/amforth.elf
gdb:
	$(CROSS)gdb-py -tui build/amforth.elf --quiet \
	-ex "target extended-remote localhost:50000" \
	-ex "directory ../../arm/dev" \
	-ex "source .gdbinit"

# More debugging references
# https://undo.io/resources/guide-to-symbols-debug-info/
