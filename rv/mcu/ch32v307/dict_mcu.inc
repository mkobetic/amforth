# SPDX-License-Identifier: GPL-3.0-only

# MFD wrong chip .include "words/pll.s"

.if WANT_QEM_BUILD
    .print "INFO: using QEM MCU words"	
    .include "words/serial.qem"
    .include "words/flash.qem"
    .include "words/flash.307"
    .include "words/eeprom.s"    
.endif

.if WANT_307_BUILD
    .print "INFO: using 307 MCU words"	
    .include "words/flash.307"  
    .include "words/usart.s"
    .include "words/gpio.s"
    .include "words/eeprom.s"    
.endif

.include "words/led.s"
.include "words/blink.s"

.include "words/env-board.s"
.include "words/build-info.s"
.include "words/applturnkey.s"

.include "words/type0.s" # not sure 

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



#.include "words/areg.s"

#.include "words/pc.s"
.include "words/wordswap.s"