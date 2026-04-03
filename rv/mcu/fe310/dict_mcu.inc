
.include "words/gpio.s"
.include "words/usart.s"

.if TARGET==HIFIVE1
     .include "words/leds.s"
.else
     .include "words/redvled.s"
.endif

.include "words/mtime.s"

.include "words/applturnkey.s"

.include "words/type0.s"

.include "words/pll.s"
.include "words/qspidiv.s"
.include "words/csr.s"


