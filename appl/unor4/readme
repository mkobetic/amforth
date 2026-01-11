# Arduino UNO R4 Wifi
https://docs.arduino.cc/hardware/uno-r4-wifi/
https://docs.freenove.com/projects/fnk0096/en/latest/
https://github.com/arduino/ArduinoCore-renesas


## MCU
Renesas R7FA4M1AB3CFM#AA0 (64pins, 5V) with FPU, 32-bit ARM Cortex M4F
256 kB FLASH: $00000000 .. $00040000
32 kB SRAM: $20000000 .. $20008000
8 Kb DATA FLASH: $40100000 .. $40102000
48 MHz
$40000000 .. $40100000 Periperheral I/O 
$407E0000 .. $407F0000 Flash I/O
https://github.com/arduino/arduino-renesas-bootloader

## USB bridge & WIFI/BLE
ESP32-S3-MINI-1-N8 (3.3V), Xtensa® dual-core 32-bit LX7
384 kB ROM
512 kB SRAM
40 MHz
https://github.com/arduino/uno-r4-wifi-usb-bridge

# Development

## Required Tools
* Arm GNU Toolchain https://developer.arm.com/downloads/-/arm-gnu-toolchain-downloads
* GDB debugger
* OpenOCD - GDB server for on chip debugging
* BOSSAC - board uploader (SAM-BA protocol)
* Golang (if you need to build the touch1200bps binary, used to put the board into bootloader mode)
* some sort of serial i/o tool, e.g. [tio](https://github.com/tio/tio)

## Make commands
* `make` builds everything and generates various listing files in ./build/
* `make upload` rebuilds and uploads to the board
* `make ocd` starts OpenOCD connected to the configured USB port
* `make gdb` starts GDB with Forth TUI and connects it to running OpenOCD server
See Makefile for more details on how to program and debug this port.

To connect to Forth running on the board start your serial monitor in 8N1 mode at 115200 bps.


## Notes

### Values

20000270 a RAM_ARM_WORDLIST
20000240 a RAM_CURRENT
20000268 a RAM_DP
20000274 a RAM_ENVIRONMENT
20000244 a RAM_FORTHRECOGNIZER
20000278 a RAM_FORTH_WORDLIST
20000248 a RAM_LP0
2000026c a RAM_RAM_WORDLIST