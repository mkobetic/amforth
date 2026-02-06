ENTRY (_start)

PVFLASH_PAGE = 0x400; /* 1K */
PVFLASH_SIZE = 0x2000; /* 8K */

MEMORY {
    /* It's all RAM we can allocate as much as we want */
    FLASH (rwx) : ORIGIN = 0x00010000, LENGTH = 1M - PVFLASH_SIZE
    PVFLASH(WRX) : ORIGIN = ORIGIN(FLASH) + LENGTH(FLASH), LENGTH = PVFLASH_SIZE
    RAM (rwx)  : ORIGIN = 0x10000000, LENGTH = 1M
}

INCLUDE amforth32.ld
