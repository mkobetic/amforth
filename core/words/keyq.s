# SPDX-License-Identifier: GPL-3.0-only
.if WANT_USB_OPERATOR
DEFER "key?",KEYQ, XT_USB_KEYQ
.else
DEFER "key?",KEYQ, XT_SERIAL_KEYQ
.endif
