
OUTPUT_FORMAT("elf32-littlearm")
OUTPUT_ARCH(arm)

/* https://github.com/Arduino/ArduinoCore-renesas/blob/main/variants/UNOWIFIR4/memory_regions.ld */

VECTOR_TABLE_LENGTH = 0x100;
FLASH_IMAGE_START = 0x4000;

/* MCU RAM parameters */
ram_start = 0x20000000;
ram_length = 0x8000;

/* MCU flash memory parameters (see RA4M1 User's Guide: 44. Flash Memory) */
code_flash_start = 0x00000000
code_flash_length = 0x40000 /* bytes */
code_flash_block_length = 2048 /* bytes */
code_flash_block_count = code_flash_length / code_flash_block_length
code_flash_write_size = 8 /* bytes */
data_flash_start = 0x40100000
data_flash_length = 0x2000 /* bytes */
data_flash_block_length = 1024 /* bytes */
data_flash_block_count = data_flash_length / data_flash_block_length
data_flash_write_size = 1 /* bytes */

/* 32-bit AmForth parameters */
cellsize = 4; /* bytes */

/* Flash parameters */
/* If amforth section should not start at the beginning of Flash,
  e.g. to protect a pre-existing bootloader you can set the offset * / 
amforth_flash_offset = FLASH_IMAGE_START /* bytes */

/* RAM parameters and layout */

/* amramlo - runtime system structures */
datastack_size = 40 * cellsize ; /* bytes */
returnstack_size = 40 * cellsize ; /* bytes */
refill_buf_size = 96 ; /* bytes */
userarea_size = (32 + 8) * cellsize ; /* bytes (sys + appl) */
leavestack_size = 8 * cellsize ; /* bytes */

/* amramhi
  fixed size rampool for variables, values, etc
  followed by ram dictionary growing up
*/
rampool_size = 4096*2 ; /* bytes */
min_ram_dict_size = 16384; /* bytes - minimum size allocated for RAM dictionary */

/* eeprom:
  future section for values persisted in data flash
  fixed size at the end of RAM
*/
eeprom_size = 256 /* bytes */

INCLUDE amforth32.ld