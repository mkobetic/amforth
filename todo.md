List of known issues and tasks that need to be done (by area)
Also look for TODO: in source files

# CORE

* review the default sizing of memory regions and sections (especially for the physical targets)
* update AmForth version
* automated compiled artifact releases
* keep WANT_SAVE?

* remove PFA_ prefix from labels that aren't PFAs
* xxx_ram symbols => RAM_xxx symbols (otherwise should be underscore prefixed)

* immediate should throw when compiling to flash
* all words should use the END macro to be proper function blocks (debug_info)
* proper, and extractable comments for all words
* add long word description to the html refcard as title attribute, so that it shows on hover

* sort out issues with `to` word (to.s/alto.s)
* don't waste 2 registers for do loop index and limit (especially on ARM)
* `LEAVE` stack is only used at compile time? Make it usable as a second parameter stack maybe?
* header flags don't each need their own bit in FFA
* runtime defined values and defers are not the same as the compile time defined ones (getters, setters, default values)
* core/aligned.s vs arm|rv/aligned.s
* aligned.s and do-aligned.s are identical
* ud* is broken, what about d*, ud/ ? (need double tests)
* remove doxliteral.s in favor of doliteral.s
* clean up all harcoded cell size values, replace with cellsize symbol (including alignment directives)


# ARM

* don't use ldm when not needed (poptos, popnos)
* `(exiti)` needs work
* better HW fault handling
* can we use LR as top of return stack?

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

* RAMALLOT reg_shadow differences between 307 ad QEM configuration
* update or remove dict_min.inc

## HIFIVE1

* get it running under qemu -M sifive_e (SiFive E31 core)


# TOOLS

* make sure all tools work
* amshell: make sure the `words` change didn't break autocomplete
* amshell: translate exception number to mnemonic
* amshell: reconsider the greedy echo loop in send_line()
* socket-shell.py duplicates most of amforth-shell.py
* keep am4up.c ?


# DOCS

* how to use AmForth32 as is
* overall architecture (core/readme.md?)
* arch specific docs (e.g. register allocation)
* how to add a new MCU
* how to add a new ARCH
* document conventions and standard practices
