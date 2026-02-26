# SPDX-License-Identifier: GPL-3.0-only

.ifdef TARGET_QEM
    .print "INFO: using QEM MCU words"	
    .include "words/serial.qem"
.endif

.include "words/applturnkey.s"

.include "words/type0.s" # not sure 

.include "words/wordswap.s"
