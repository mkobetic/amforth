OUTPUT_ARCH( "riscv" )

ENTRY( _start )

/* Not enough memory to support pvalues practically */
PVFLASH_PAGE = 0;
PVFLASH_CELL = 0;
PVFLASH_ERASED = flash_erased;

/* !! Memory regions are defined early and their parameters MUST NOT be computed from object file symbols !! */
MEMORY
{
   /* FLASH(RX)   : ORIGIN = 0x20400000, LENGTH = 32K */
   FLASH(RX)   : ORIGIN = 0x20010000, LENGTH =  64K
   RAM(WAIXL)  : ORIGIN = 0x80000000, LENGTH =  16K
   /* MUST define the PVFLASH region otherwise it will default to occupying the entire memory space */
   PVFLASH(RW) : ORIGIN = 0 , LENGTH = 0
}

INCLUDE amforth32.ld
