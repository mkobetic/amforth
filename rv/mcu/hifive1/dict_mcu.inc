
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
    
# EEPROM

COLON "eeprom.warm" , EEPROMDOTWARM
# ( -- ) EEPROM:
    .word XT_EXIT

COLON "eeprom.init" , EEPROMDOTINIT
# ( -- ) EEPROM: if first run init eeprom and std flash page 
    .word XT_EXIT

VALUE "eeprom.empty?"   , EEPROMDOTEMPTYQ,0

