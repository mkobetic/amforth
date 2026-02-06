OUTPUT_ARCH( "riscv" )

ENTRY( PFA_COLD )

/* There's so little memory that we can't really have pvalues here */
PVFLASH_PAGE = 0;
PVFLASH_SIZE = 0;

MEMORY
{
   FLASH(RX)   : ORIGIN = 0x20400000, LENGTH = 0x8000
   RAM(WAIXL)  : ORIGIN = 0x80000000, LENGTH = 0x4000
   /* Use must define the PVFLASH region otherwise it will default to occupying the entire memory space */
   PVFLASH(RW) : ORIGIN = 0 , LENGTH = PVFLASH_SIZE
}

INCLUDE amforth32.ld