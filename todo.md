List of know issues and tasks that need to be done (by area)


# CORE

* sort out issues with `to` word (to.s/alto.s)
* rv not vs arm not (logical vs bitwise)
* figure out if values should have setter/getter XTs
* add END macro and make all words proper function blocks (debug_info)
* review/simplify word flags
* ARM: 2rot and rot is the same thing (see RV)
* invert and not is the same thing?
* add refcard legend

* stepping through XT_DOLITERAL is very painful, should we have something simpler? (constants are)
* core/aligned.s vs arm|rv/aligned.s
* aligned.s and do-aligned.s are identical
* remove doxliteral.s in favor of doliteral.s
* remove HIDEWORD in favor of HEADLESS
* clean/document amforth32.ld (assumptions, section purpose, etc)
* clean up all harcoded cell size values, replace with cellsize symbol (including alignment directives)

* a way to build different configurations for a given MCU
* Standardized Makefile targets across all MCUs 
* Extract OS and personal details from Makefiles (.env files?)
* Automated compiled artifact releases
* proper, and extractable comments for all words
* automated ref-card generation
* figure out what to do about docs
* document conventions and standard practices
* document dev tool setup
* add enabled feature list to the greeting


# ARM

* what is the relationship between variable `rp` and `sp`, and register `sp` and `psp` ?
* don't push{lr}/pop{pc} in leaf functions (just bx lr)
* don't use ldm when not needed (poptos, popnos)
* add readme.md
* (exiti) likely needs work
* document dev tool setup
* better HW fault handling

## LM4F120

## RA4M1

* make sure FLASH_IMAGE_START is handled correctly
* flash dictionary updates

## LINUX

# RISC-V
* add readme.md
* generalize flash dictionary write support (flash.s)
* generalize eeprom support (eeprom.s)
* generalize GDB extensions to support RISC-V

## CH32V307
* RAMALLOT reg_shadow differences between 307 ad QEM configuration

## HIFIVE1
* get it running under qemu -M sifive_e (SiFive E31 core)


# TOOLS
* document/instrument Python setup for the tools
* make sure all tools work