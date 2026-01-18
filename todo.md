List of know issues and tasks that need to be done (by area)


# CORE

* [ ] core/aligned.s vs arm|rv/aligned.s
* [ ] aligned.s and do-aligned.s are identical
* [ ] remove doxliteral.s in favor of doliteral.s
* [ ] remove HIDEWORD in favor of HEADLESS
* [ ] document amforth32.ld (assumptions, section purpose, etc)
* [ ] move non-address constants from amforth32.ld to config.inc? (cellsize, region sizes, etc...)

* [ ] CI compilation tests
* [ ] CI core tests (emulated)
* [ ] Standardized Makefile targets across all apps 
* [ ] Extract OS and personal details from Makefiles (.env files?)
* [ ] Automated compiled artifact releases
* [ ] proper, and extractable comments for all words
* [ ] automated ref-card generation
* [ ] figure out what to do about docs
* [ ] document conventions and standard practices
* [ ] document dev tool setup


# ARM

* [ ] implement m-rot.s (see rv)
* [ ] implement umstar.s (see rv)
* [ ] (exiti) likely needs work
* [ ] document dev tool setup

## LM4F120

## RA4M1

* [ ] make sure FLASH_IMAGE_START is handled correctly
* [ ] flash dictionary updates

## LINUX
* [ ] fix compilation bugs


# RISC-V
* [ ] generalize flash dictionary write support (flash.s)
* [ ] generalize eeprom support (eeprom.s)

## CH32V307

## HIFIVE1
* [ ] get it running under qemu -M sifive_e (SiFive E31 core)


# TOOLS
* [ ] document/instrument Python setup for the tools
* [ ] make sure all tools work