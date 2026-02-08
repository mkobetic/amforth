OUTPUT_ARCH( "riscv" )

ENTRY( PFA_COLD )

/* TODO: this is made up, needs correcting */
FLASH_PAGE = 1K ; 
FLASH_CELL = 1 ; /* bytes */
FLASH_SIZE = 32K ; 
FLASH_ERASED = 0xFFFFFFFF; /* a word in erased flash */

/* Not enough memory to support pvalues practically */
PVFLASH_PAGE = 0;
PVFLASH_CELL = 0;
PVFLASH_SIZE = 0;
PVFLASH_ERASED = FLASH_ERASED;

MEMORY
{
   FLASH(RX)   : ORIGIN = 0x20400000, LENGTH = FLASH_SIZE
   RAM(WAIXL)  : ORIGIN = 0x80000000, LENGTH = 0x4000
   /* MUST define the PVFLASH region otherwise it will default to occupying the entire memory space */
   PVFLASH(RW) : ORIGIN = 0 , LENGTH = PVFLASH_SIZE
}

INCLUDE amforth32.ld