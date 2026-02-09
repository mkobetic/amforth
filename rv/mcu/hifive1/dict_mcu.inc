
.include "words/gpio.s"

.include "words/usart.s"

#.include "words/flash.s"
.include "words/leds.s"
.include "words/mtime.s"

.include "words/env-board.s"
.include "words/build-info.s"
.include "words/applturnkey.s"

.include "words/type0.s"

.include "words/csr.s"

# PLACEHOLDERS FOR MISSING FUNCTIONALITY

# TODO: This doesn't do flash, unlike the RV side
# ( h addr -- ) Write a half word h to addr
COLON "h,", HCOMMA
	.word XT_DP
	.word XT_HSTORE
	.word XT_TWO
	.word XT_DALLOT
	.word XT_EXIT

# FLASH

COLON "!i", BANGI
    .word XT_EXIT
    
# EEPROM

COLON "eeprom.warm" , EEPROMDOTWARM
# ( -- ) EEPROM:
    .word XT_EXIT

COLON "eeprom.init" , EEPROMDOTINIT
# ( -- ) EEPROM: if first run init eeprom and std flash page 
    .word XT_EXIT

CONSTANT "core-wordlist" , CORE_WORDLIST , core_wordlist
VALUE "eeprom.empty?"   , EEPROMDOTEMPTYQ,0

