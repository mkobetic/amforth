# SPDX-License-Identifier: GPL-3.0-only





# MFD wrong chip .include "words/pll.s"

.if WANT_QEM_BUILD
    .include "words/serial.qem"        
.else
    .include "words/usart.s"
    .include "words/gpio.s"     
.endif

# MFD wrong chip .include "words/qspidiv.s"

# MFD include "words/flash.s" as in dict_prims
.include "words/led.s"
.include "words/blink.s"

.include "words/env-board.s"
#include "words/build-info.s"
.include "words/applturnkey.s"

.include "words/type0.s" # not sure 

# MFD .include "words/qtest.s"
.if WANT_SYSTICK
.include "words/systick.s"
.endif

.include "words/reset.s"

.if WANT_TIMER6
.include "words/t6.s"
.include "words/t8.s"
.include "words/t9.s"
.endif

#.include "words/temp6.s"
.include "words/usb.s"
#.include "words/debug.s"
#.include "words/frag.s"

.if WANT_FLOAT
    .include "words/float.s"
.endif

.include "words/eeprom.s"
