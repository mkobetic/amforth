# SPDX-License-Identifier: GPL-3.0-only
# AmForth-RV Makefile

# Credit to below
# https://github.com/wuxx/CH32V003-makefile-example

# COLORS
BLACK  := $(shell tput -Txterm setaf 0)
RED    := $(shell tput -Txterm setaf 1)
GREEN  := $(shell tput -Txterm setaf 2)
YELLOW := $(shell tput -Txterm setaf 3)
VIOLET := $(shell tput -Txterm setaf 5)
AQUA   := $(shell tput -Txterm setaf 6)
WHITE  := $(shell tput -Txterm setaf 7)
RESET  := $(shell tput -Txterm sgr0)


AMFORTH ?= $(shell git rev-parse --show-toplevel)

# Choices 

ARDUINO=TRUE  # TRUE for Arduino tool chain, FALSE for ZEPHYR 

# ----------------------------------------------------------------------
# extracted from config.inc

ASMONLY:=$(shell perl -n -e ' if(/.equ\s+WANT_ASM_BUILD\s*,\s+(YES|NO)/){print $$1;}' ./config.inc)
WANT_FLOAT:=$(shell perl -n -e ' if(/.equ\s+WANT_FLOAT\s*,\s+(YES|NO)/){print $$1;exit;}' ./config.inc)
WANT_SEE:=$(shell perl -n -e ' if(/.equ\s+WANT_SEE\s*,\s+(YES|NO)/){print $$1;exit;}' ./config.inc)
WANT_CASE:=$(shell perl -n -e ' if(/.equ\s+WANT_CASE\s*,\s+(YES|NO)/){print $$1;exit;}' ./config.inc)
WANT_MATCH:=$(shell perl -n -e ' if(/.equ\s+WANT_MATCH\s*,\s+(YES|NO)/){print $$1;exit;}' ./config.inc)
WANT_TABLE:=$(shell perl -n -e ' if(/.equ\s+WANT_TABLE\s*,\s+(YES|NO)/){print $$1;exit;}' ./config.inc)
WANT_FORNEXT:=$(shell perl -n -e ' if(/.equ\s+WANT_FORNEXT\s*,\s+(YES|NO)/){print $$1;exit;}' ./config.inc)

# ----------------------------------------------------------------------
# Variables that will probably need to be changed to suit your setup 

# Include personal environment settings.
# Following variables should be set:
# * MODEM - the serial device used to connect to the board, e.g /dev/cu.usbmodem...
# * WLINK - command to execute the WLINK flash uploader
# * QEMU_RV32 - command to execute qemu-system-riscv32
# * OPENOCD - command to execute OpenOCD
# * OPENCFG - path to OpenOCD configuration file for CH32V307
# Including after config so that personal settings can reflect the config.
-include .env

QEMU_RV32 ?= qemu-system-riscv32
WLINK ?= $(HOME)/.cargo/bin/wlink
MINICOM ?= minicom

SOCKSHELL=$(AMFORTH)/tools/socket-shell.py --port $(MODEM) --speed 115200 $1
UU=$(AMFORTH)/tools/uu

# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
# Guessing variables based on operating system

OS = $(shell uname) # Darwin is macOS else is assumed Linux

ifeq ($(strip $(OS)),Darwin)
# This is the base Arduino package dir (DO NOT LEAVE TRAILING WHITESPACE)
ARDU15 := $(HOME)/Library/Arduino15
else
# This is the base Arduino package dir (DO NOT LEAVE TRAILING WHITESPACE)
ARDU15 := $(HOME)/.arduino15
endif

# This is the base ZEPHYR dir (DO NOT LEAVE TRAILING WHITESPACE)
ZEPHYR := $(HOME)/zephyr-sdk-0.16.4
# This is the base of the WCH C library (DO NOT LEAVE TRAILING WHITESPACE)

# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------

# Decide which toolchain to use.
# If local toolchain is installed, use that,
# otherwise use what $(ARDUINO) says
ifeq ($(wildcard $(TC_DIR)),)
ifeq ($(strip $(ARDUINO)),TRUE)
TC_DIR = $(ARDU15)/packages/WCH/tools/riscv-none-embed-gcc/8.2.0
CROSS = riscv-none-embed-
TOOLCHAIN = WCH-via-Arduino
OPENOCD = $(ARDU15)/packages/WCH/tools/openocd/1.0.0/bin/openocd
OPENCFG = $(ARDU15)/packages/WCH/tools/openocd/1.0.0/bin/wch-riscv.cfg
else
TC_DIR = $(ZEPHYR)/riscv64-zephyr-elf
CROSS = riscv64-zephyr-elf-
TOOLCHAIN=Zephyr
endif
else
TOOLCHAIN=Local-Toolchain
endif

# Set library directories based on chip variant
CHIPSET=

# Default target to build
TARGET ?= 307
$(info TARGET: $(TARGET))

ifeq ($(strip $(TARGET)),203)
CHIPSET=203
MCU_LD := ./linker.203
LIB_WCH := ./lib_203
LIB_USER := ./lib_203_user
else ifeq ($(strip $(TARGET)),305)
CHIPSET=305
MCU_LD := ./linker.305
LIB_WCH := ./wch307
LIB_USER := ./lib_wch_user
else ifeq ($(strip $(TARGET)),307)
CHIPSET=307
MCU_LD := ./linker.307
LIB_WCH := ./wch307
LIB_USER := ./lib_wch_user
else ifeq ($(strip $(TARGET)),QEM)
CHIPSET=QEM
MCU_LD := ./linker.qem
LIB_WCH := ./lib_qem
LIB_USER := ./lib_qem_user
else 
$(error Unknown target configuration $(TARGET))
endif

# Included after various configuration bits are defined (importantly MCU_LD)
include $(AMFORTH)/rv/dev/Makefile


TARGET_NAME := amforth
TARGET_ELF  := $(TARGET_NAME).elf
TARGET_HEX  := $(TARGET_NAME).hex
TARGET_BIN  := $(TARGET_NAME).bin
TARGET_MAP  := $(TARGET_NAME).map
TARGET_LIST := $(TARGET_NAME).list

BUILD_DIR := build

# Source directories based on build type
ifeq ($(strip $(ASMONLY)),YES)
SRC_DIRS := .
SRCS = $(shell find $(SRC_DIRS) -name "*.S" | sed 's|^./||')
else
SRC_DIRS := $(LIB_WCH) $(LIB_USER) .
SRCS = $(shell find $(SRC_DIRS) -type d -name Startup -prune -name "*.cpp" -or -name "*.c" -or -name "*.S")
endif

OBJS = $(SRCS:%=$(BUILD_DIR)/%.o)
#DEPS = $(OBJS:.o=.d)

LIB_OBJS  := $(filter $(BUILD_DIR)/$(LIB_WCH)/%,$(OBJS)) \
             $(filter $(BUILD_DIR)/$(LIB_USER)/%,$(OBJS)) 

USER_OBJS := $(filter-out $(BUILD_DIR)/$(LIB_WCH)/% \
                          $(BUILD_DIR)/$(LIB_USER)/%,$(OBJS))

INCLUDES := -I . $(INCLUDES)


# Compiler flags 
FLAGS := -Wa,--defsym,BUILD_$(strip $(TARGET))=YES -msmall-data-limit=8 -mno-save-restore -Os -Wunused -Wuninitialized -g
ifeq ($(strip $(TARGET)),203)
FLAGS += -march=rv32imac -mabi=ilp32 
else
FLAGS += -march=rv32imafc -mabi=ilp32f
endif

# Needed for the INCLUDE amforth32.ld to work in linked files (-L must preceed the -T !!!)
FLAGS += -L $(AMFORTH)/core

DEFINES := -DSYSCLK_FREQ_96MHz

# Need WANT_IGNORECASE if running core tests
ifdef WANT_IGNORECASE
DEFINES += -Wa,--defsym,WANT_IGNORECASE=1
endif

#ASFLAGS  := $(FLAGS) -x assembler $(INCLUDES) -MMD -MP $(DEFINES) 
ASFLAGS  := $(FLAGS) -x assembler-with-cpp  $(INCLUDES) -MMD -MP $(DEFINES) 
CPPFLAGS := $(FLAGS) $(INCLUDES) -MMD -MP $(DEFINES)

#LDFLAGS += -nostartfiles -Xlinker -t -Xlinker --gc-sections -Xlinker --verbose --specs=nano.specs --specs=nosys.specs \
                                                -Xlinker -Map $(BUILD_DIR)/$(TARGET_MAP)

# ----------------------------------------------------------------------
# Targets below 
# ----------------------------------------------------------------------

## Show help
help:
	@echo 'Usage: [TARGET=<target config>] make${RESET} ${GREEN}<make target>${RESET}'
	@echo '<target config> is one of 307, 305, 203, QEM'
	@echo ''
	@echo 'Compiler, assembler and library:'
	@printf "  ${YELLOW}TOOLCHAIN${RESET}\t\t$(TOOLCHAIN)\n"
	@printf "  ${YELLOW}CHIP VARIANT${RESET}\t\t$(CHIPSET)\n"
	@printf "  ${YELLOW}VENDOR LIB${RESET}\t\t$(LIB_WCH)\n"
	@printf "  ${YELLOW}USER LIB${RESET}\t\t$(LIB_USER)\n"
	@printf "  ${YELLOW}HEX FILE${RESET}\t\t$(BUILD_DIR)/$(TARGET_HEX)\n"
	@echo ''
	@printf "Build options extracted from ${RED}top${RESET} of config.inc\n"
	@printf "  ${YELLOW}WANT_ASM_BUILD${RESET}\t${ASMONLY} (will override some options)\n"
	@printf "  ${YELLOW}WANT_FLOAT${RESET}\t\t$(WANT_FLOAT)\n"
	@printf "  ${YELLOW}WANT_SEE${RESET}\t\t${WANT_SEE}\n"
	@printf "  ${YELLOW}WANT_CASE${RESET}\t\t${WANT_CASE}\n"
	@printf "  ${YELLOW}WANT_MATCH${RESET}\t\t${WANT_MATCH}\n"
	@printf "  ${YELLOW}WANT_TABLE${RESET}\t\t${WANT_TABLE}\n"
	@printf "  ${YELLOW}WANT_FORNEXT${RESET}\t\t${WANT_FORNEXT}\n"
	@echo ''
	@echo 'Make targets:'
	@awk '/^#\? / { \
	text = substr($$0, 4); \
	printf "  %s\n", text; \
	} \
	/^[a-zA-Z\-_0-9]+:/ { \
	helpMessage = match(lastLine, /^## (.*)/); \
	if (helpMessage) { \
	helpCommand = substr($$1, 0, index($$1, ":")-1); \
	helpMessage = substr(lastLine, RSTART + 2, RLENGTH); \
	printf "  ${GREEN}%-$(TARGET_MAX_CHAR_NUM)s${RESET}\t%s${RESET}\n", helpCommand, helpMessage; \
	} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST)


# ----------------------------------------------------------------------
# ----------------------------------------------------------------------

# For some reason make decides at the end of the build that amforth.s is an intermediate file and deletes it.
# You will see a spurious `rm amforth.s` at the end of the build.
# Interestingly, even though our file is named amforth.S, it gets deleted on MacOS anyway,
# because MacOS filesystem is case-insensitive (unfortunately).
# .PRECIOUS overrides make's inferred cleanup attempt.
.PRECIOUS: amforth.s

## Build hex file (will clean first)
all: clean $(BUILD_DIR)/$(TARGET_ELF)
	@echo INFO: Built $(BUILD_DIR)/$(TARGET_ELF) for target $(TARGET) using $(TOOLCHAIN)

# Create static library from:
# - lib_wch or lib_203 (vendor peripheral drivers)
# - lib_wch_user or lib_203_user (optional user C code)
# Only created if there are library objects (not ASMONLY build)
$(BUILD_DIR)/libcode.a: $(LIB_OBJS)
ifneq ($(strip $(LIB_OBJS)),)
	$(RM) $@
	ar rcs $@ $^
	$(RANLIB) $@
else
	@echo "No library objects to archive (ASMONLY build)"
	@touch $@
endif

# Link: User objects (always) + library (selective)
# Directory structure:
#   ./User                -> USER_OBJS (always linked directly)
#   ./lib_wch_user|203    -> LIB_OBJS  (selectively linked from archive)
#   ./lib_wch|203         -> LIB_OBJS  (selectively linked from archive)
# NOTE: This duplicates the target from core/dev/Makefile, but this one is more specific (and last) so it will win,
#  however dependencies of both targets are collected and executed, so this will run some unnecessary steps from core
#  resulting in unnecessary files in build/
$(BUILD_DIR)/$(TARGET_ELF): $(USER_OBJS) $(BUILD_DIR)/libcode.a
ifneq ($(strip $(LIB_OBJS)),)
	$(CC) $(FLAGS) -T $(MCU_LD) -nostartfiles -o $@ $(USER_OBJS) -Wl,--start-group $(BUILD_DIR)/libcode.a -Wl,--end-group --verbose --specs=nano.specs --specs=nosys.specs
else
	$(CC) $(FLAGS) -T $(MCU_LD) -nostartfiles -o $@ $(USER_OBJS) --verbose --specs=nano.specs --specs=nosys.specs
endif
	$(OBJCOPY) -Oihex   $@ $(BUILD_DIR)/$(TARGET_HEX)
	$(OBJCOPY) -Obinary $@ $(BUILD_DIR)/$(TARGET_BIN)
	$(OBJDUMP) -m riscv:rv32 -M no-aliases --show-raw-insn --insn-width=4 --all-headers --demangle -d $(BUILD_DIR)/$(TARGET_ELF) > $(BUILD_DIR)/$(TARGET_LIST)
	$(SIZE) $(BUILD_DIR)/$(TARGET_ELF)
	$(OBJDUMP) -t $(BUILD_DIR)/$(TARGET_ELF) | sort > $(BUILD_DIR)/symtab

# assembly
$(BUILD_DIR)/%.S.o: %.S buildinfo
	$(CC) $(ASFLAGS) -c $< -o $@

# c source
$(BUILD_DIR)/%.c.o: %.c buildinfo
	$(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

# c++ source
$(BUILD_DIR)/%.cpp.o: %.cpp buildinfo
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $< -o $@


.PHONY: clean info shell speed save uu 

## Connect via USB 
uu:
	$(UU) 

w:
	$(AMSHELL) --no-error-on-output -i ./w.f

float:
	$(AMSHELL) --no-error-on-output -i ./float.f

speed:
	time $(AMSHELL) --no-error-on-output tester-amforth.frt

## Run gdb 
gdb:
	$(BIN_STUB)-gdb --ex 'target extended-remote :3333' $(BUILD_DIR)/$(TARGET_ELF)

## Run openocd 
open:
	$(OPENOCD) -f $(OPENCFG)

## Connect via minicom 
min:
	$(RM) minicom.cap
	$(MINICOM) -D $(MODEM) --color=on -C minicom.cap

## Flash hex file to the device  
flash:
	$(WLINK) flash $(BUILD_DIR)/$(TARGET_HEX)

debug:
	@echo "Configuration:"
	@echo "  WANT_203 = $(WANT_203)"
	@echo "  LIB_WCH = $(LIB_WCH)"
	@echo "  LIB_USER = $(LIB_USER)"
	@echo "  ASMONLY = $(ASMONLY)"
	@echo ""
	@echo "USER_OBJS (always linked):"
	@echo "$(USER_OBJS)" | tr ' ' '\n'
	@echo ""
	@echo "LIB_OBJS (selectively linked):"
	@echo "$(LIB_OBJS)" | tr ' ' '\n'
	@echo "INC (selectively linked):"
	@echo "$(INCLUDES)" | tr ' ' '\n'

#? --- QEM ---
QEMU := $(QEMU_RV32) -M virt -display none -bios none -kernel $(BUILD_DIR)/$(TARGET_ELF)

## redirect operator uart to stdio
stdio:
	$(QEMU) -serial stdio

## create with socket
sock:
	$(QEMU) -serial tcp:localhost:4321,server,nowait  # need to terminate

## socket shell  
sksh:
	$(SOCKSHELL) --no-error-on-output -i 

 
