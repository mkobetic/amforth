# SPDX-License-Identifier: GPL-3.0-only
# options

.include "core/config.inc"


.equ RA_FLASH        , YES
.equ FLUSH_REQUIRED  , YES

.ifdef RA_FLASH
       .print "INFO: using RA_FLASH"	
.endif

.ifdef FLUSH_REQUIRED
       .print "INFO: using FLUSH_REQUIRED"	
.endif

