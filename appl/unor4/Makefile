
REVISION := $(shell git status -bs -u no|tr / -)
CROSS=arm-none-eabi-
LANG=C
BOARD = unor4

# Based on what Arduino IDE uses to program the Uno R4
# https://www.shumatech.com/web/products/bossa
# https://github.com/arduino/BOSSA
BOSSAC=/Users/martin/Library/Arduino15/packages/arduino/tools/bossac/1.9.1-arduino5/bossac
# BOSSAC = bossac
PORT=cu.usbmodemB43A45B4700C2

buildinfo: 
	cat words/build-info.tmpl | sed "s/%d/ `date`/" | sed "s/%r/${REVISION}/" > words/build-info.s

build/%.o: %.s words/*.s buildinfo
	$(CROSS)as -g --warn --fatal-warnings -achlms=build/unor4.list -I../../arm -I ../../arm/devices/cortex-m4 -I ../../shared -o $@ $<

build/unor4.elf: build/unor4.o
	$(CROSS)ld -T memmap $< -o $@

build/%.lst: build/%.elf
	$(CROSS)objdump -DSt -j amforth $< >$@

build/%.sym: build/%.elf
	$(CROSS)nm -l $< >$@

build/%.hex: build/%.elf
	$(CROSS)objcopy -O ihex $< $@

build/%.bin: build/%.elf
	$(CROSS)objcopy -O binary $< $@

all: build/unor4.hex build/unor4.lst build/unor4.sym

clean:
	rm build/* words/build-info.s

# N.B.: The BOSSA_LOADER always stores the file at FLASH_IMAGE_START (+offset),
# 		so DO NOT use -o to enforce FLASH_IMAGE_START!
# see https://github.com/arduino/arduino-renesas-bootloader/blob/main/src/bossa.c#L272
#
# The board must be in bootloader mode for bossac to be able to communicate with it.
# The LED soft pulses at 1 sec intervals when in bootloader mode.
# To put the board into bootloader mode manually, press and release the RESET button twice.
# Alternatively the touch2100bps utility can achieve the same as well.
#
# Note: it seems only the Arduino version of bossac works with UNO R4 (https://github.com/arduino/BOSSA)
upload: build/unor4.bin touch1200bps
	touch1200bps/touch1200bps /dev/$(PORT)
	$(BOSSAC) --debug --port=$(PORT) --write build/unor4.bin

touch1200bps: touch1200bps/*
	cd ./touch1200bps && go build

PHONY: buildinfo clean upload touch1200bps ocd gdb

ARDUINO_LIB = /Users/martin/Library/Arduino15/packages/arduino
ARDUINO_PLUGINS = /Applications/Arduino IDE.app/Contents/Resources/app/plugins
OPENOCD = $(ARDUINO_LIB)/tools/openocd/0.11.0-arduino2


# Start OpenOCD
# You can connect to the telnet port with: nc localhost 50002
ocd: build/unor4.elf
	$(OPENOCD)/bin/openocd -c "gdb_port 50000" -c "tcl_port 50001" -c "telnet_port 50002" \
	-f "$(ARDUINO_PLUGINS)/cortex-debug/extension/support/openocd-helpers.tcl" \
	-f $(OPENOCD)/share/openocd/scripts/interface/cmsis-dap.cfg \
	-f dev/select_swd.cfg \
	-f dev/R7FA4M1AB.cfg

# Start gdb and connect to OpenOCD
gdb: build/unor4.elf
	$(CROSS)gdb -tui build/unor4.elf \
    -ex "layout asm" \
	-ex "layout reg" \
	-ex "target extended-remote localhost:50000"
# 	-ex "b PFA_LED_INIT" \
# 	-ex "monitor reset"


# More debugging references
# https://undo.io/resources/guide-to-symbols-debug-info/