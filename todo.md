List of know issues and tasks that need to be done (by area)


# CORE

* [ ] core/aligned.s vs arm|rv/aligned.s
* [ ] aligned.s and do-aligned.s are identical
* [ ] remove doxliteral.s in favor of doliteral.s
* [ ] remove HIDEWORD in favor of HEADLESS
* [ ] document amforth32.ld (assumptions, section purpose, etc)
* [x] move non-address constants from amforth32.ld to config.inc? (cellsize, region sizes, etc...)
* [ ] is the RAM_upper/lower_fi area used for anything?

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

* [x] implement CHAR+
* [x] fix core test freeze
* [ ] add readme.md
* [x] implement m-rot.s (see rv)
* [x] implement umstar.s (see rv)
* [ ] (exiti) likely needs work
* [ ] we are not using the link register, would it speed things up if it was used to cache DO_NEXT?
      (i.e. macro NEXT would do `b lr` instead of `b DO_NEXT`)

## LM4F120

## RA4M1

* [ ] make sure FLASH_IMAGE_START is handled correctly
* [ ] flash dictionary updates

## LINUX
* [x] fix compilation bugs


# RISC-V
* [ ] implement native um/mod and optimize for narrow arguments (see ARM)

## CH32V307
* [ ] RAMALLOT reg_shadow differences between 307 ad QEM configuration

## HIFIVE1
* [x] fix compilation
* [ ] get it running under qemu -M sifive_e (SiFive E31 core)


# TOOLS
* [ ] document/instrument Python setup for the tools
* [ ] make sure all tools work