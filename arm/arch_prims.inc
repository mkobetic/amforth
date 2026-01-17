# PLACEHOLDERS FOR MISSING FUNCTIONALITY

// TODO: This doesn't do flash, unlike the RV side
// ( h addr -- ) Write a half word h to addr
COLON "h,", HCOMMA
	.word XT_DP
	.word XT_HSTORE
	.word XT_TWO
	.word XT_DALLOT
	.word XT_EXIT

# FLASH

COLON "std.unlock", STDDOTUNLOCK
# ( -- ) FLASH: Unlock flash
    .word XT_EXIT

CODEWORD "std.erase" , STDDOTERASE
# ( a-flash -- ) FLASH: Erase 256B page flash-a is in 
    .word XT_EXIT

COLON "!i", BANGI
    .word XT_EXIT

CONSTANT "flash.low"    , FLASH_LOW   , flash.low
    
# EEPROM

COLON "eeprom.warm" , EEPROMDOTWARM
# ( -- ) EEPROM:
    .word XT_EXIT

COLON "eeprom.init" , EEPROMDOTINIT
# ( -- ) EEPROM: if first run init eeprom and std flash page 
    .word XT_EXIT

CONSTANT "core-wordlist" , CORE_WORDLIST , core_wordlist
VALUE "eeprom.empty?"   , EEPROMDOTEMPTYQ,0

