# SPDX-License-Identifier: GPL-3.0-only

ENVIRONMENT "cpu", CPU /* ( -- addr u ) string with cpu identifier */
       STRING "RV32IMAFC"
       .word XT_EXIT
END CPU

ENVIRONMENT "build-type", BUILD_TYPE
.if WANT_ASM_BUILD
       STRING "ASM"
.else  
       STRING "C+ASM"
.endif       
      .word XT_EXIT
END BUILD_TYPE
