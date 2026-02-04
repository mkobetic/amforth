List of know issues and tasks that need to be done (by area)


# CORE

* [ ] 2rot and rot is the same thing?
* [ ] what exactly does compare do? What is the return value? Length suffixed strings?
* [ ] review/simplify word flags
* [ ] add END macro and make all words proper function blocks (debug_info)

* [ ] core/aligned.s vs arm|rv/aligned.s
* [ ] aligned.s and do-aligned.s are identical
* [ ] remove doxliteral.s in favor of doliteral.s
* [ ] remove HIDEWORD in favor of HEADLESS
* [ ] document amforth32.ld (assumptions, section purpose, etc)
* [ ] is the RAM_upper/lower_fi area used for anything?
* [ ] clean up all harcoded cell size values, replace with cellsize symbol (including alignment directives)

* [ ] a way to build different configurations for a given MCU
* [x] CI compilation tests
* [x] CI core tests (emulated)
* [ ] Standardized Makefile targets across all MCUs 
* [ ] Extract OS and personal details from Makefiles (.env files?)
* [ ] Automated compiled artifact releases
* [ ] proper, and extractable comments for all words
* [ ] automated ref-card generation
* [ ] figure out what to do about docs
* [ ] document conventions and standard practices
* [ ] document dev tool setup
* [ ] add enabled feature list to the greeting


# ARM

* [ ] what is the relationship between variable `rp` and `sp` ?
* [ ] don't push{lr}/pop{pc} in leaf functions (just bx lr)
* [ ] don't use ldm when not needed (poptos, popnos)
* [ ] add readme.md
* [ ] (exiti) likely needs work
* [ ] document dev tool setup
* [ ] better HW fault handling

## LM4F120

## RA4M1

* [ ] make sure FLASH_IMAGE_START is handled correctly
* [ ] flash dictionary updates

## LINUX
* [x] fix compilation bugs


# RISC-V
* [ ] add readme.md
* [ ] generalize flash dictionary write support (flash.s)
* [ ] generalize eeprom support (eeprom.s)
* [ ] generalize GDB extensions to support RISC-V

## CH32V307
* [ ] RAMALLOT reg_shadow differences between 307 ad QEM configuration

## HIFIVE1
* [x] fix compilation
* [ ] get it running under qemu -M sifive_e (SiFive E31 core)


# TOOLS
* [ ] document/instrument Python setup for the tools
* [ ] make sure all tools work