# AmForth 32-bit

This is the shared basis of all 32-bit versions of AmForth.

Words in shared/words are combined with architecture specific words (RISC-V/words, ARM/words, ...)
and with architecture compatible application/board specific words, e.g.
* risc-v/words + appl/hifive1/words, or
* arm/words + appl/launchpad-arm/words

# Architecture

## Memory layout

### Code Flash Memory / ROM

This is persistent, executable memory that contains primarily the predefined AmForth words. The end of the used part of this memory is tracked by the `dp.flash` pointer. User defined words can be copied from RAM into the code flash memory with the word `save`. This will allow the word to survive a hardware reset.

### RAM

This a non-peristent, executable memory used for multiple purposes. It is divided into 2 sections RAMLO and RAMHI.

RAMLO is used to support runtime needs of AmForth, it houses things like the parameter and return stacks, user block, system buffers etc.

RAMHI is again divided into 2 sections.

RAMHI lower part is used for variable values and other application uses. The end of the used part of this section is tracked with `vp` pointer.

RAMHI higher part stores definitions of user defined words. The end of the used part of this section is tracked with `dp.ram` pointer.

### Data Flash Memory / EEPROM

This is a persistent, non-executable memory. It used to persist AmForth values and other application uses. Design yet to be finalized.


## Dictionary word layout

The 32-bit word header layout is somewhat different from the 8-bit word layout. The header field order is different.
In AmForth the execution token (XT) is the CFA.

| Field | Size   | Description
| ----- | ------ | ----------------------------------
| LFA   | .word  | (LFA) points to FFA of prior word
| FFA   | .word  | (FFA) word flags
| NFA   | .bytes | (NFA) length prefixed string containing the name of the word
| CFA   | .word  | (CFA) points to executable code implementing the word
|       |        | for code-words (CFA) = PFA
| PFA   | .bytes | (PFA) word parameters compiled into the word definition
|       |        | for colon-words PFA is a sequence of .words interpreted by the inner interpreter ending with XT_EXIT
|       |        | for code-words PFA is machine code implementing the word ending with NEXT macro expansion
|       |        | for other word types the contents of PFA can be interpreted in completely arbitrary way

Words that are compiled into the AmForth binary have corresponding symbols defined that map to:
* LFA - VE_ symbol
* CFA - XT_ symbol
* PFA - PFA_ sybmol

## Wordlists and Search Order

To be continued
