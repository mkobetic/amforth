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


YES=TRUE
NO=FALSE

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
WANT_203:=$(shell perl -n -e ' if(/.equ\s+WANT_203_BUILD\s*,\s+(YES|NO)/){print $$1;exit;}' ./config.inc)
WANT_QEM:=$(shell perl -n -e ' if(/.equ\s+WANT_QEM_BUILD\s*,\s+(YES|NO)/){print $$1;exit;}' ./config.inc)
WANT_307:=$(shell perl -n -e ' if(/.equ\s+WANT_307_BUILD\s*,\s+(YES|NO)/){print $$1;exit;}' ./config.inc)
WANT_305:=$(shell perl -n -e ' if(/.equ\s+WANT_305_BUILD\s*,\s+(YES|NO)/){print $$1;exit;}' ./config.inc)

# ----------------------------------------------------------------------
# Variables that will probably need to be changed to suit your setup 

MINICOM=/opt/homebrew/bin/minicom
MINICOM=/usr/local/bin/minicom
AMSHELL=./tools/amforth-shell.py --port $(MODEM) --speed 115200 $1
SOCKSHELL=./tools/socket-shell.py --port $(MODEM) --speed 115200 $1

UU=$(ROOT)/tools/uu

ifeq ($(strip $(WANT_203)),YES)
MODEM=/dev/tty.usbmodem0B358F0690082
else
MODEM=/dev/tty.usbmodem507D8F06D5502
endif

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


ROOT := ../..
TARGET_NAME := amforth
TARGET_ELF  := $(TARGET_NAME).elf
TARGET_HEX  := $(TARGET_NAME).hex
TARGET_BIN  := $(TARGET_NAME).bin
TARGET_MAP  := $(TARGET_NAME).map
TARGET_LIST := $(TARGET_NAME).list

ifeq ($(strip $(ARDUINO)),TRUE)
BIN_STUB=$(ARDU15)/packages/WCH/tools/riscv-none-embed-gcc/8.2.0/bin/riscv-none-embed
TOOLCHAIN=WCH-via-Arduino
else
BIN_STUB=/Users/tw/zephyr-sdk-0.16.4/riscv64-zephyr-elf/bin/riscv64-zephyr-elf
TOOLCHAIN=Zephyr
endif

QEMU_TOOLS=/opt/homebrew/bin

MKDIR_P=mkdir -p
LD :=$(BIN_STUB)-ld
AS := $(BIN_STUB)-gcc
CC := $(BIN_STUB)-gcc
CXX := $(BIN_STUB)-g++
OBJCOPY := $(BIN_STUB)-objcopy
OBJDUMP := $(BIN_STUB)-objdump
OBJSIZE := $(BIN_STUB)-size
RANLIB := $(BIN_STUB)-ranlib
OPENOCD := $(ARDU15)/packages/WCH/tools/openocd/1.0.0/bin/openocd
OPENCFG := $(ARDU15)/packages/WCH/tools/openocd/1.0.0/bin/wch-riscv.cfg
SRCR := $(HOME)/ng/dev/uc/AmForth-RV/appl/ch32v307/cpp/MRSC/CH32V307VCT6

# Set library directories based on chip variant
CHIPSET=

ifeq ($(strip $(WANT_203)),YES)
CHIPSET=203
LD_FILE := ./linker.203
LIB_WCH := ./lib_203
LIB_USER := ./lib_203_user
endif

ifeq ($(strip $(WANT_305)),YES)
CHIPSET=305
LD_FILE := ./linker.305
LIB_WCH := ./wch307
LIB_USER := ./lib_wch_user
endif

ifeq ($(strip $(WANT_307)),YES)
CHIPSET=307
LD_FILE := ./linker.307
LIB_WCH := ./wch307
LIB_USER := ./lib_wch_user
endif

ifeq ($(strip $(WANT_QEM)),YES)
CHIPSET=QEM
LD_FILE := ./linker.qem
LIB_WCH := ./lib_qem
LIB_USER := ./lib_qem_user
endif

BUILD_DIR := ./build

# Source directories based on build type
ifeq ($(strip $(ASMONLY)),YES)
SRC_DIRS := .
SRCS = $(shell find $(SRC_DIRS) -name "*.S")
else
SRC_DIRS := $(LIB_WCH) $(LIB_USER) .
SRCS = $(shell find $(SRC_DIRS) -type d -name Startup -prune -name "*.cpp" -or -name "*.c" -or -name "*.S")
endif

OBJS = $(SRCS:%=$(BUILD_DIR)/%.o)
DEPS = $(OBJS:.o=.d)

LIB_OBJS  := $(filter $(BUILD_DIR)/$(LIB_WCH)/%,$(OBJS)) \
             $(filter $(BUILD_DIR)/$(LIB_USER)/%,$(OBJS)) 

USER_OBJS := $(filter-out $(BUILD_DIR)/$(LIB_WCH)/% \
                          $(BUILD_DIR)/$(LIB_USER)/%,$(OBJS))

INC_FLAGS := -I . -I ../../risc-v -I ../../shared

# Compiler flags 
ifeq ($(strip $(WANT_203)),YES)
FLAGS := -march=rv32imac -mabi=ilp32 -msmall-data-limit=8 -mno-save-restore -Os -Wunused -Wuninitialized -g
else
FLAGS := -march=rv32imafc -mabi=ilp32f -msmall-data-limit=8 -mno-save-restore -Os -Wunused -Wuninitialized -g
endif

# Needed for the INCLUDE amforth32.ld to work in linked files (-L must preceed the -T !!!)
FLAGS += -L ../../shared

DEFINES  := -DSYSCLK_FREQ_96MHz
#ASFLAGS  := $(FLAGS) -x assembler $(INC_FLAGS) -MMD -MP $(DEFINES) 
ASFLAGS  := $(FLAGS) -x assembler-with-cpp  $(INC_FLAGS) -MMD -MP $(DEFINES) 
CPPFLAGS := $(FLAGS) $(INC_FLAGS) -MMD -MP $(DEFINES)

LDFLAGS := $(FLAGS) -T $(LD_FILE) -nostartfiles -Xlinker -t -Xlinker --gc-sections -Xlinker --verbose --specs=nano.specs --specs=nosys.specs \
                                                -Xlinker -Map $(BUILD_DIR)/$(TARGET_MAP)

# ----------------------------------------------------------------------
# Targets below 
# ----------------------------------------------------------------------

## Show help
help:
	@echo 'Usage: make${RESET} ${GREEN}<target>${RESET}'
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
	@echo 'Targets:'
	@awk '/^#\? / { \
	text = substr($$0, 4); \
	printf "  %s\n", text; \
	} \
	/^[a-zA-Z\-_0-9]+:/ { \
	helpMessage = match(lastLine, /^## (.*)/); \
	if (helpMessage) { \
	helpCommand = substr($$1, 0, index($$1, ":")-1); \
	helpMessage = substr(lastLine, RSTART + 2, RLENGTH); \
	printf "  ${GREEN}%-$(TARGET_MAX_CHAR_NUM)s${RESET}\t${BLACK}%s${RESET}\n", helpCommand, helpMessage; \
	} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST)


# ----------------------------------------------------------------------
# ----------------------------------------------------------------------

## Build hex file (will clean first)
all: clean $(BUILD_DIR)/$(TARGET_ELF)
	@echo Building $(BUILD_DIR)/$(TARGET_ELF)

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
$(BUILD_DIR)/$(TARGET_ELF): $(USER_OBJS) $(BUILD_DIR)/libcode.a
ifneq ($(strip $(LIB_OBJS)),)
	$(CC) $(FLAGS) -T $(LD_FILE) -nostartfiles -o $@ $(USER_OBJS) -Wl,--start-group $(BUILD_DIR)/libcode.a -Wl,--end-group --verbose --specs=nano.specs --specs=nosys.specs
else
	$(CC) $(FLAGS) -T $(LD_FILE) -nostartfiles -o $@ $(USER_OBJS) --verbose --specs=nano.specs --specs=nosys.specs
endif
	$(OBJCOPY) -Oihex   $@ $(BUILD_DIR)/$(TARGET_HEX)
	$(OBJCOPY) -Obinary $@ $(BUILD_DIR)/$(TARGET_BIN)
	$(OBJDUMP) -m riscv:rv32 -M no-aliases --show-raw-insn --insn-width=4 --all-headers --demangle -d $(BUILD_DIR)/$(TARGET_ELF) > $(BUILD_DIR)/$(TARGET_LIST)
	$(OBJSIZE) $(BUILD_DIR)/$(TARGET_ELF)
	$(OBJDUMP) -t $(BUILD_DIR)/$(TARGET_ELF) | sort > $(BUILD_DIR)/symtab
	@echo "Toolchain was $(TOOLCHAIN)"

# assembly
$(BUILD_DIR)/%.S.o: %.S
	$(MKDIR_P) $(dir $@)
	$(CC) $(ASFLAGS) -c $< -o $@

# c source
$(BUILD_DIR)/%.c.o: %.c
	$(MKDIR_P) $(dir $@)
	$(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

# c++ source
$(BUILD_DIR)/%.cpp.o: %.cpp
	$(MKDIR_P) $(dir $@)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $< -o $@


.PHONY: clean info shell speed save uu 

## Connect via AmShell 
shell:
	export EDITOR=emacs
	$(AMSHELL) --no-error-on-output -i 

## Connect via USB 
uu:
	export EDITOR=emacs
	$(UU) 

w:
	export EDITOR=emacs
	$(AMSHELL) --no-error-on-output -i ./w.f

float:
	export EDITOR=emacs
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

## Update build info - run before build 
info:
	cat mcu-words/build-info.tmpl | sed "s/%d/`date`/" | sed "s/%r/${REVISION}/" > mcu-words/build-info.s

## Flash hex file to the device  
flash:
	$(HOME)/.cargo/bin/wlink flash $(BUILD_DIR)/$(TARGET_HEX)

## Clean - run before build
clean:
	$(RM) -r $(BUILD_DIR)

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
	@echo "$(INC_FLAGS)" | tr ' ' '\n'

#? --- QEM ---
## redirect operator uart to stdio
stdio:
	$(QEMU_TOOLS)/qemu-system-riscv32 -M virt -display none -bios none -kernel $(BUILD_DIR)/$(TARGET_ELF) -serial stdio    

## create with socket
sock:
	$(QEMU_TOOLS)/qemu-system-riscv32 -M virt -bios none -kernel $(BUILD_DIR)/$(TARGET_ELF) \
    -serial tcp:localhost:4321,server,nowait -display none                                                  

## socket shell  
sksh:
	export EDITOR=emacs
	$(SOCKSHELL) --no-error-on-output -i 

 
