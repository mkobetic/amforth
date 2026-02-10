ENTRY (_start)

/* It's all RAM we can allocate as much as we want */
PVFLASH_PAGE = flash_page;
PVFLASH_CELL = flash_cell;
PVFLASH_ERASED = flash_erased;
PVFLASH_SIZE = 8K;

MEMORY {
    FLASH (rwx) : ORIGIN = 0x00010000, LENGTH = flash_size - PVFLASH_SIZE
    PVFLASH(WRX) : ORIGIN = ORIGIN(FLASH) + LENGTH(FLASH), LENGTH = PVFLASH_SIZE
    RAM (rwx)  : ORIGIN = 0x10000000, LENGTH = 1M
}

INCLUDE amforth32.ld
