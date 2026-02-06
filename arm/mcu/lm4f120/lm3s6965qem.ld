
OUTPUT_FORMAT("elf32-littlearm")
OUTPUT_ARCH(arm)

PVFLASH_PAGE = 1K;
PVFLASH_SIZE = 8K;

MEMORY
{
    FLASH(RX)   : ORIGIN = 0x00000000, LENGTH = 0x40000
    RAM(WAIL) : ORIGIN = 0x20000000, LENGTH = 0x10000 - PVFLASH_SIZE
    /* Cannot write into emulated flash so allocate the end of RAM as faux PVFLASH */
    PVFLASH(WRX) : ORIGIN = ORIGIN(RAM) + LENGTH(RAM), LENGTH = PVFLASH_SIZE
}

INCLUDE amforth32.ld
