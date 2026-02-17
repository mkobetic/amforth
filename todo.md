List of know issues and tasks that need to be done (by area)


# CORE

* CH32: junk in flash can prevent reuse of dictionary pages
* RA4: compiling across flash page boundary breaks compilation (dallot unfinished?)
* rv not vs arm not (logical vs bitwise), also invert and not is the same thing
* clean up placeholders in dict_mcu.s files
* !i must not be permitted to write below dp0.flash (!i vs ~!i)
* ARM: 2rot and rot is the same thing (see RV)
* review/simplify word flags
* sort out issues with `to` word (to.s/alto.s)
* add END macro and make all words proper function blocks (debug_info)
* clean/document amforth32.ld (assumptions, section purpose, etc)
* add refcard legend
* Makefile: build/amforth.dep setup forces second amforth.o compilation

* add words to show memory stats

* push WANT_USB_OPERATOR, TARGET_QEM out of core (into ch32)
* core/aligned.s vs arm|rv/aligned.s
* aligned.s and do-aligned.s are identical
* remove doxliteral.s in favor of doliteral.s
* remove HIDEWORD in favor of HEADLESS
* what is the relationship between variable `rp` and `sp`, and register `sp` and `psp` ?
* clean up all harcoded cell size values, replace with cellsize symbol (including alignment directives)
* add long word description to the html refcard as title attribute, so that it shows on hover

* add selected options to build-info (e.g. WANT_IGNORECASE)
* make target for listing unused words/ files (see build/amforth.dep)
* standardized Makefile targets across all MCUs 
* extract OS and personal details from Makefiles (.env files?)
* automated compiled artifact releases
* proper, and extractable comments for all words
* automated ref-card generation
* figure out what to do about docs
* document conventions and standard practices
* document dev tool setup


# ARM

* add readme.md
* don't push{lr}/pop{pc} in leaf functions (just bx lr)
* don't use ldm when not needed (poptos, popnos)
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

* make dtests is failing


# RISC-V

* add readme.md
* generalize GDB extensions to support RISC-V

## CH32V307

* flash.qem vs flash.307 vs flash.s
* a lot of code duplication between flash and eeprom
* unify the build setup with the rest of MCUs (gcc vs as)
* RAMALLOT reg_shadow differences between 307 ad QEM configuration

## HIFIVE1

* get it running under qemu -M sifive_e (SiFive E31 core)


# TOOLS

* document/instrument Python setup for the tools
* make sure all tools work
* amshell: translate exception number to mnemonic


# DOCS

* how to use AmForth32 as is
* overall architecture (core/readme.md?)
* describe the development setup
* how to add a new MCU
* how to add a new ARCH