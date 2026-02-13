# PLACEHOLDERS FOR MISSING FUNCTIONALITY
    
# EEPROM

COLON "eeprom.warm" , EEPROMDOTWARM
# ( -- ) EEPROM:
    .word XT_EXIT

COLON "eeprom.init" , EEPROMDOTINIT
# ( -- ) EEPROM: if first run init eeprom and std flash page 
    .word XT_EXIT

VALUE "eeprom.empty?"   , EEPROMDOTEMPTYQ,0

