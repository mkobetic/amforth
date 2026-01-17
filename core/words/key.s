# SPDX-License-Identifier: GPL-3.0-only
.if WANT_USB_OPERATOR
DEFER "key", KEY, XT_USB_KEY_PAUSE
.else
DEFER "key", KEY, XT_SERIAL_KEY_PAUSE
.endif

COLON "serial-key-pause" , SERIAL_KEY_PAUSE
    .word XT_PAUSE,XT_SERIAL_KEYQ, XT_DOCONDBRANCH, PFA_SERIAL_KEY_PAUSE
    .word XT_SERIAL_KEY
    .word XT_EXIT

# this I want visible 


#VARIABLE "cnt" , CNT 

#: usb-key? ( -- f ) rxc @ #16 ashift cnt @ - 0= invert ;
#: usb-key  ( -- c ) cnt @ dup rxu + c@ swap 1+ $ff and cnt ! ;  



