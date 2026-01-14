# SPDX-License-Identifier: GPL-3.0-only

ENVIRONMENT "board", BOARD

.if WANT_203_BUILD
    STRING "WCH CH32V203"
.endif

.if WANT_307_BUILD
    STRING "WCH CH32V307"
.endif

.if WANT_305_BUILD
    STRING "WCH CH32V305"
.endif

.if WANT_QEM_BUILD
    STRING "QEMU"
.endif

.word XT_EXIT

