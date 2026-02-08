
OUTPUT_FORMAT("elf32-littlearm")
OUTPUT_ARCH(arm)

FLASH_SIZE = 256K;
/* TODO: this is made up, needs correcting */
FLASH_PAGE = 1K;
FLASH_CELL = 4; /* bytes */
FLASH_ERASED = 0xFFFFFFFF; /* a word in erased flash */

/* RAM emulated PVFLASH */
PVFLASH_PAGE = 1K;
PVFLASH_CELL = 4; /* bytes */
PVFLASH_ERASED = FLASH_ERASED;
PVFLASH_SIZE = 8K;

MEMORY
{
    FLASH(RX)   : ORIGIN = 0x00000000, LENGTH = 0x40000
    RAM(WAIL) : ORIGIN = 0x20000000, LENGTH = 0x10000 - PVFLASH_SIZE
    /* Cannot write into emulated flash so allocate the end of RAM as faux PVFLASH */
    PVFLASH(WRX) : ORIGIN = ORIGIN(RAM) + LENGTH(RAM), LENGTH = PVFLASH_SIZE
}

INCLUDE amforth32.ld
