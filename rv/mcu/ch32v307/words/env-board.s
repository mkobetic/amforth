# SPDX-License-Identifier: GPL-3.0-only

ENVIRONMENT "board", BOARD

.ifdef BUILD_203
    STRING "WCH CH32V203"
.endif

.ifdef BUILD_307
    STRING "WCH CH32V307"
.endif

.ifdef BUILD_305
    STRING "WCH CH32V305"
.endif

.ifdef BUILD_QEM
    STRING "QEMU"
.endif

.word XT_EXIT

