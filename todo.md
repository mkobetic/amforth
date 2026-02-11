List of know issues and tasks that need to be done (by area)


# CORE

* rv not vs arm not (logical vs bitwise), also invert and not is the same thing
* !i must not be permitted to write below dp0.flash
* sort out issues with `to` word (to.s/alto.s)
* figure out if value setter/getter XTs are used and drop them if not
* add END macro and make all words proper function blocks (debug_info)
* review/simplify word flags
* ARM: 2rot and rot is the same thing (see RV)
* clean/document amforth32.ld (assumptions, section purpose, etc)
* add refcard legend

* core/aligned.s vs arm|rv/aligned.s
* aligned.s and do-aligned.s are identical
* remove doxliteral.s in favor of doliteral.s
* remove HIDEWORD in favor of HEADLESS
* what is the relationship between variable `rp` and `sp`, and register `sp` and `psp` ?
* clean up all harcoded cell size values, replace with cellsize symbol (including alignment directives)
* add long word description to the html refcard as title attribute, so that it shows on hover

* add selected options to build-info (e.g. WANT_IGNORECASE)
* make target for listing unused words/ files (see build/amforth.dep)
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

* don't push{lr}/pop{pc} in leaf functions (just bx lr)
* don't use ldm when not needed (poptos, popnos)
* add readme.md
* (exiti) likely needs work
* document dev tool setup
* better HW fault handling

## LM4F120

* review the settings of the various targets
* is flash.s only for lm4 or does it work for the lm3 targets too?

## RA4M1

* make sure FLASH_IMAGE_START is handled correctly
* flash dictionary updates

## LINUX

# RISC-V

* add readme.md
* generalize GDB extensions to support RISC-V

## CH32V307

* unify the build setup with the rest of MCUs (gcc vs as)
* RAMALLOT reg_shadow differences between 307 ad QEM configuration
* generalize eeprom support (eeprom.s)

## HIFIVE1

* get it running under qemu -M sifive_e (SiFive E31 core)

# TOOLS

* document/instrument Python setup for the tools
* make sure all tools work

# DOCS

* how to use AmForth32 as is
* overall architecture (core/readme.md?)
* describe the development setup
* how to add a new MCU
* how to add a new ARCH