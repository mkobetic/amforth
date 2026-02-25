List of know issues and tasks that need to be done (by area)
Also look for TODO: in source files

# CORE

* replace PFA_ labels that aren't PFAs with transient labels 1f, 2b...
* do we need the CON macro?
* xxx_ram symbols => RAM_xxx symbols (otherwise should be underscore prefixed)
* review/simplify word flags

* add words to show memory stats
* extend the error prompt to list words on the R-stack to help identify where the throw comes from
* add selected options to build-info (e.g. WANT_IGNORECASE)
* add BUILD_CONFIG to the greeting

* all words should use the END macro to be proper function blocks (debug_info)
* sort out issues with `to` word (to.s/alto.s)
* runtime defined values and defers are not the same as the compile time defined ones (getters, setters, default values)
* core/aligned.s vs arm|rv/aligned.s
* aligned.s and do-aligned.s are identical
* ud* is broken, what about d*, ud/ ? (need double tests)
* remove doxliteral.s in favor of doliteral.s
* clean up all harcoded cell size values, replace with cellsize symbol (including alignment directives)

* automated compiled artifact releases
* add refcard legend
* proper, and extractable comments for all words
* add long word description to the html refcard as title attribute, so that it shows on hover


# ARM

* don't push{lr}/pop{pc} in leaf functions (just bx lr)
* don't use ldm when not needed (poptos, popnos)
* (exiti) likely needs work
* better HW fault handling

## LM4F120

* review the settings of the various targets
* is flash.s only for lm4 or does it work for the lm3 targets too?

## RA4M1

* make sure FLASH_IMAGE_START is handled correctly

## LINUX

* make dtests is failing


# RISC-V

* CI caching of qemu installation (or maybe try docker instead?)

## CH32V307

* flash.qem vs flash.307 vs flash.s
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
* arch specific docs (e.g. register allocation)
* describe the development setup
* how to add a new MCU
* how to add a new ARCH
* document conventions and standard practices
* document dev tool setup
