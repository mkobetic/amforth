COLON "hifive-turnkey", APPLTURNKEY

  .word XT_LED_INIT
  .word XT_DECIMAL

/* setup for 256MHz via PLL with 115200 */

  .word XT_PLL
  .word XT_QSPIDIV
  .word XT_INIT_USART  

  .word XT_DOT_VER, XT_SPACE
  .word XT_ENV_BOARD,XT_TYPE, XT_CR
  .word XT_ENV_DOT_BUILD                                                        

  .word XT_EXIT
END APPLTURNKEY


