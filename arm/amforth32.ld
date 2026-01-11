
ram_end = ram_start + ram_length

MEMORY
{
  FLASH (rx)      : ORIGIN = code_flash_start, LENGTH = code_flash_length
  RAM (rwx)       : ORIGIN = ram_start, LENGTH = ram_length
  DATA_FLASH (rx) : ORIGIN = data_flash_start, LENGTH = data_flash_length
}

SECTIONS
{

  amforth : {
    . = amforth_flash_offset;
    . = ALIGN( cellsize ) ;
    PROVIDE( flash.low = . );
    *(amforth);  
    *(.text);    
    *(.data);
  } > FLASH


  eeprom : {
    . = ALIGN(256) ;
    PROVIDE( eeprom = . );
    FILL(0xDEADBEEF);
    . = . + 256 - 1 ;  
    BYTE(0);
  } >FLASH

  userdict : {
    . = ALIGN(4096) ;
    PROVIDE( dp0.flash = . );
    PROVIDE( flash.high = . );
    PROVIDE( flash.max = code_flash_start + code_flash_length );
  } >FLASH
    
  amramlo : {
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

  amramhi : {
    PROVIDE( vp0 = . ) ;
    . = . + rampool_size ;
    PROVIDE( vp.max = . ) ;
    
    . = ALIGN(4) ;
    
    PROVIDE( dp0.ram = . ) ; 
    PROVIDE( HERESTART = . ) ;
  } > RAM

  dp0.ram.ceiling = ram_end - eeprom_size
  ASSERT( < dp0.ram + min_ram_dict_size, "Insufficient space for RAM dictionary!")

  .eeprom ram_end - eeprom_size :
  {
    . = ALIGN(4);
    PROVIDE( eeprom_buf = . );
    . = . + eeprom_size;
  } >RAM 
}