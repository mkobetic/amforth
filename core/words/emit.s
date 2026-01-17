# SPDX-License-Identifier: GPL-3.0-only
.if WANT_USB_OPERATOR
DEFER "emit", EMIT, XT_USB_EMIT_PAUSE
.else
DEFER "emit", EMIT, XT_SERIAL_EMIT_PAUSE
.endif 

COLON "serial-emit-pause" , SERIAL_EMIT_PAUSE
# ( c -- ) SERIAL: emit c on serial connection or pause if unable  
    .word XT_PAUSE,XT_SERIAL_EMITQ, XT_DOCONDBRANCH, PFA_SERIAL_EMIT_PAUSE
    .word XT_SERIAL_EMIT
    .word XT_EXIT
