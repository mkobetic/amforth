ENTRY (_start)

MEMORY {
    FLASH (rwx) : ORIGIN = 0x00010000, LENGTH = 1M
    RAM (rwx)  : ORIGIN = 0x10000000, LENGTH = 1M
}

INCLUDE amforth32.ld