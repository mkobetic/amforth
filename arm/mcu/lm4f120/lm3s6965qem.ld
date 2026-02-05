
OUTPUT_FORMAT("elf32-littlearm")
OUTPUT_ARCH(arm)

DataFlashSize = 0x2000;

MEMORY
{
    FLASH(RX)   : ORIGIN = 0x00000000, LENGTH = 0x40000
    RAM(WAIL) : ORIGIN = 0x20000000, LENGTH = 0x10000 - DataFlashSize
    /* Cannot write into emulated flash so allocate the end of RAM as faux DATA_FLASH */
    DATA_FLASH(WRX) : ORIGIN = ORIGIN(RAM) + LENGTH(RAM), LENGTH = DataFlashSize
}

INCLUDE amforth32.ld

SECTIONS {
   /* predefined size of pvalue arenas, use whole DATA_FLASH */
   PROVIDE(pvasize = DataFlashSize / 2);

   pvarena1 : {
      PROVIDE(pvarena1_lower = . );
      . = . + pvasize;
      PROVIDE(pvarena1_upper = .);
   } >DATA_FLASH

   pvarena2 : {
      PROVIDE(pvarena2_lower = . );
      . = . + pvasize;
      PROVIDE(pvarena2_upper = .);
   } >DATA_FLASH
}