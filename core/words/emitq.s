# SPDX-License-Identifier: GPL-3.0-only
.if WANT_USB_OPERATOR
DEFER "emit?",EMITQ, XT_USB_EMITQ
.else
DEFER "emit?",EMITQ, XT_SERIAL_EMITQ
.endif
