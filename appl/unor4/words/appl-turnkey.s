
COLON "appl-turnkey", APPLTURNKEY
  .word XT_DECIMAL
  # TODO: UART not working yet
  .word XT_UART_INIT
  .word XT_DOT_VER

  .word XT_SPACE,XT_ENV_BOARD,XT_TYPE, XT_CR
  .word XT_BUILD_INFO,XT_TYPE, XT_SPACE, XT_REV_INFO, XT_TYPE
  .word XT_DELAY_INIT
  .word XT_LED_INIT
  
# for now just flash the LED forever
LED_BLINK_LOOP:
  .word XT_LED_ON, XT_DOLITERAL, 50000, XT_MS
  .word XT_LED_OFF, XT_DOLITERAL, 50000, XT_MS
  .word XT_DOLOOP, LED_BLINK_LOOP

.word XT_EXIT
