/* SPDX-License-Identifier: GPL-3.0-only */

cellsize = 4 ;

__stack_size = 2048;
PROVIDE( _stack_size = __stack_size );

SECTIONS
{

	.init :
	{
        flash.base = . ;	/* QEMU */ 
		_sinit = .;
		. = ALIGN(4);
		KEEP(*(SORT_NONE(.init)))
		. = ALIGN(4);
		_einit = .;
	} >FLASH AT>FLASH

  .vector :
  {
      *(.vector);
	  . = ALIGN(64);
  } >FLASH AT>FLASH

	.text :
	{
		. = ALIGN(4);
                *(EXCLUDE_FILE(*amforth.o).text)        
                
		*(.text)
		*(.text.*)
		*(.rodata)
		*(.rodata*)
		*(.gnu.linkonce.t.*)
		. = ALIGN(4);
	} >FLASH AT>FLASH 

	.fini :
	{
		KEEP(*(SORT_NONE(.fini)))
		. = ALIGN(4);
	} >FLASH AT>FLASH

	PROVIDE( _etext = . );
	PROVIDE( _eitcm = . );	

	.preinit_array  :
	{
	  PROVIDE_HIDDEN (__preinit_array_start = .);
	  KEEP (*(.preinit_array))
	  PROVIDE_HIDDEN (__preinit_array_end = .);
	} >FLASH AT>FLASH 
	
	.init_array     :
	{
	  PROVIDE_HIDDEN (__init_array_start = .);
	  KEEP (*(SORT_BY_INIT_PRIORITY(.init_array.*) SORT_BY_INIT_PRIORITY(.ctors.*)))
	  KEEP (*(.init_array EXCLUDE_FILE (*crtbegin.o *crtbegin?.o *crtend.o *crtend?.o ) .ctors))
	  PROVIDE_HIDDEN (__init_array_end = .);
	} >FLASH AT>FLASH 
	
	.fini_array     :
	{
	  PROVIDE_HIDDEN (__fini_array_start = .);
	  KEEP (*(SORT_BY_INIT_PRIORITY(.fini_array.*) SORT_BY_INIT_PRIORITY(.dtors.*)))
	  KEEP (*(.fini_array EXCLUDE_FILE (*crtbegin.o *crtbegin?.o *crtend.o *crtend?.o ) .dtors))
	  PROVIDE_HIDDEN (__fini_array_end = .);
	} >FLASH AT>FLASH 
	
	.ctors          :
	{
	  /* gcc uses crtbegin.o to find the start of
	     the constructors, so we make sure it is
	     first.  Because this is a wildcard, it
	     doesn't matter if the user does not
	     actually link against crtbegin.o; the
	     linker won't look for a file to match a
	     wildcard.  The wildcard also means that it
	     doesn't matter which directory crtbegin.o
	     is in.  */
	  KEEP (*crtbegin.o(.ctors))
	  KEEP (*crtbegin?.o(.ctors))
	  /* We don't want to include the .ctor section from
	     the crtend.o file until after the sorted ctors.
	     The .ctor section from the crtend file contains the
	     end of ctors marker and it must be last */
	  KEEP (*(EXCLUDE_FILE (*crtend.o *crtend?.o ) .ctors))
	  KEEP (*(SORT(.ctors.*)))
	  KEEP (*(.ctors))
	} >FLASH AT>FLASH 
	
	.dtors          :
	{
	  KEEP (*crtbegin.o(.dtors))
	  KEEP (*crtbegin?.o(.dtors))
	  KEEP (*(EXCLUDE_FILE (*crtend.o *crtend?.o ) .dtors))
	  KEEP (*(SORT(.dtors.*)))
	  KEEP (*(.dtors))
	} >FLASH AT>FLASH 

        amforth :
        {
            . = ALIGN( cellsize ) ;
            PROVIDE( flash.low = . );
            *(amforth)
            *amforth.o(.text .text.*)

        } >FLASH AT>FLASH

        eeprom :
        {
            . = ALIGN(256) ;
            PROVIDE( eeprom = . );
            FILL(0xDEADBEEF);
            . = . + 256 - 1 ;  
            BYTE(0);

        } >FLASH AT>FLASH

        userdict :
        {
            . = ALIGN(4096) ;
            PROVIDE( dp0.flash = . );
            PROVIDE( flash.high = . );
            PROVIDE( flash.max = ORIGIN(FLASH) + LENGTH(FLASH));
        } >FLASH AT>FLASH

	.dalign :
	{
		. = ALIGN(4);
		PROVIDE(_data_vma = .);
	} >RAM AT>FLASH	

	.dlalign :
	{
		. = ALIGN(4); 
		PROVIDE(_data_lma = .);
	} >FLASH AT>FLASH

	.data :
	{
    	*(.gnu.linkonce.r.*)
    	*(.data .data.*)
    	*(.gnu.linkonce.d.*)
		. = ALIGN(8);
    	PROVIDE( __global_pointer$ = . + 0x800 );
    	*(.sdata .sdata.*)
		*(.sdata2.*)
    	*(.gnu.linkonce.s.*)
    	. = ALIGN(8);
    	*(.srodata.cst16)
    	*(.srodata.cst8)
    	*(.srodata.cst4)
    	*(.srodata.cst2)
    	*(.srodata .srodata.*)
    	. = ALIGN(4);
		PROVIDE( _edata = .);
	} >RAM AT>FLASH

	.bss :
	{
		. = ALIGN(4);
		PROVIDE( _sbss = .);
  	    *(.sbss*)
        *(.gnu.linkonce.sb.*)
		*(.bss*)
     	*(.gnu.linkonce.b.*)		
		*(COMMON*)
		. = ALIGN(4);
		PROVIDE( _ebss = .);
        PROVIDE( ram_ripe = .); /* QEMU */
	} >RAM AT>FLASH

	PROVIDE( _end = _ebss);
	PROVIDE( end = . );

    rampool_size = 4096*2 ;
    returnstack_size = 40 * 4 ;
    datastack_size = 40 * 4 ; 
    refill_buf_size = 96 ;
    userarea_size = 2*4 + 32*4 ;
    leavestack_size = 8*4 ;
    

    amramlo :
    {
        . = ALIGN(256) ;
        
        PROVIDE(RAM_lower_fi = . ) ;
        . = . + 256 ;
        PROVIDE(RAM_upper_fi = . ) ;

        PROVIDE(ram_vector_base = . ) ;
        . = . + 256 * 4 ;
        PROVIDE(RAM_upper_ram_vector_base = . ) ;
        
        PROVIDE(reg_shadow = . ) ;
        . = . + 256 ;
        PROVIDE(RAM_upper_reg_shadow = . ) ;

        PROVIDE(RAM_lower_datastack = . ) ;
        . = . + datastack_size ;
        PROVIDE(RAM_upper_datastack = . ) ;

        . = . + 4 ;

        PROVIDE(RAM_lower_returnstack = . ) ;
        . = . + returnstack_size  ;      
        PROVIDE(RAM_upper_returnstack = . ) ;

        . = . + 4 ;
        
        PROVIDE(RAM_lower_refill_buf  = . ) ;
        . = . + refill_buf_size ;               
        PROVIDE(RAM_upper_refill_buf = . ) ;

        . = . + 4 ;
        
        PROVIDE(RAM_lower_userarea  = . ) ;
        . = . + userarea_size ;
        PROVIDE(RAM_upper_userarea  = . ) ;

        . = . + 4 ;
        
        PROVIDE(RAM_lower_leavestack = . ) ;
        . = . + leavestack_size ; 
        PROVIDE(RAM_upper_leavestack = . ) ;

        . = . + 4 ;
        

    } >RAM

    amramhi :
    {
        PROVIDE( vp0 = . ) ;
        . = . + rampool_size ;
        PROVIDE( vp.max = . ) ;
        
        . = ALIGN(4) ;
        
        PROVIDE( dp0.ram = . ) ; 
        PROVIDE( HERESTART = . ) ;

    } > RAM 

    slack = cellsize ;

    .stack ORIGIN(RAM) + LENGTH(RAM) - __stack_size  - eeprom_size - slack :
    {
        PROVIDE( _heap_end = . );    
        . = ALIGN(4);
        PROVIDE(_susrstack = . );
        . = . + __stack_size;
        PROVIDE( _eusrstack = .);
    } >RAM

    eeprom_size = 256 ;
    
    .eeprom ORIGIN(RAM) + LENGTH(RAM) - eeprom_size :
    {
        . = ALIGN(4);
        PROVIDE( eeprom_buf = . );

        . = . + eeprom_size;
    } >RAM 

ASSERT(_eusrstack == ORIGIN(RAM) + LENGTH(RAM) - eeprom_size - slack, "Stack and EEPROM overlap!")

    PROVIDE(rampointer = rampool_end);
}
