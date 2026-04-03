-include .env

TARGET ?= REDFIVE
TARGETS = REDFIVE HIFIVE1

CHIPSET=$(TARGET)
MCU_LD := ./$(TARGET).ld
LIB_WCH := ./lib_$(TARGET)
LIB_USER := ./lib_$(TARGET)_user

BOARD ?= $(TARGET)
AMFORTH ?= $(shell git rev-parse --show-toplevel)

QEMU_RV32?=qemu-system-riscv32

ifeq ($(strip $(TARGET)),REDFIVE)
QEMU:=$(QEMU_RV32) -M sifive_e,revb=true -bios none -kernel build/amforth.elf
## Upload hex file to the device
upload:
	cp build/amforth.hex /Volumes/HiFive
else                                                                                        
QEMU:=$(QEMU_RV32) -M sifive_e           -bios none -kernel build/amforth.elf
upload:
	echo "no upload for $(TARGET) available"
endif    

# Included after various configuration bits are defined (importantly MCU_LD)
include $(AMFORTH)/rv/dev/Makefile

## Start AmForth under QEMU with operator uart connected to stdio
stdio:
	$(QEMU) -display none -serial stdio

## make tcp server connection on localhost:4444 available
socket:
	$(QEMU) -display none \
    -chardev socket,id=sock0,host=127.0.0.1,port=4444,server=on,wait=on,logfile=/tmp/serial.log \
    -serial chardev:sock0

## make telnet server connection on localhost:4444 available (socket better)
telser:
	$(QEMU) \
    -serial telnet:127.0.0.1:4444,server=on,wait=on, -display none 

## run socket-shell connecting to localhost:4444
socks:
	$(AMFORTH)/tools/socket-shell.py --no-error-on-output -i --ignore-error

## run netcat with readline wrap connecting to localhost:4444
nc:
	rlwrap nc localhost 4444

