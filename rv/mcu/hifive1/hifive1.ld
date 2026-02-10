OUTPUT_ARCH( "riscv" )

ENTRY( PFA_COLD )

/* Not enough memory to support pvalues practically */
PVFLASH_PAGE = 0;
PVFLASH_CELL = 0;
PVFLASH_SIZE = 0;
PVFLASH_ERASED = flash_erased;

MEMORY
{
   FLASH(RX)   : ORIGIN = 0x20400000, LENGTH = flash_size
   RAM(WAIXL)  : ORIGIN = 0x80000000, LENGTH = 0x4000
   /* MUST define the PVFLASH region otherwise it will default to occupying the entire memory space */
   PVFLASH(RW) : ORIGIN = 0 , LENGTH = PVFLASH_SIZE
}

INCLUDE amforth32.ld