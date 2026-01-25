# SPDX-License-Identifier: GPL-3.0-only
.ifdef BUILD_203
    ENVIRONMENT "cpu", CPU
       STRING "RV32IMAC"
      .word XT_EXIT
.else
    ENVIRONMENT "cpu", CPU
       STRING "RV32IMAFC"
       .word XT_EXIT
.endif

ENVIRONMENT "build-type", BUILD_TYPE
.if WANT_ASM_BUILD
       STRING "ASM"
.else  
       STRING "C+ASM"
.endif       
      .word XT_EXIT
