# SPDX-License-Identifier: GPL-3.0-only
# amforth.S 

.globl PFA_COLD 

# startup ----------------------------------------------------------------------

# this is placed in section .init but is included here are values from config.inc
# are needed by both C and AmForth-RV 

.include "config.inc"   # most configuration options are in this file

.if WANT_203_BUILD
.print "INFO: using 203 startup"	
.include "startup.203"  # startup and master_int handler for both C and Forth
.endif

.if WANT_305_BUILD
.print "INFO: using 307 startup"		
.include "startup.307"  # startup and master_int handler for both C and Forth
.endif 

.if WANT_307_BUILD
.print "INFO: using 307 startup"		
.include "startup.307"  # startup and master_int handler for both C and Forth
.endif 

.if WANT_QEM_BUILD
.print "INFO: using QEM startup"		
.include "startup.qem"  # startup and master_int handler for both C and Forth
.endif 


# amforth --------------------------------------------

.section amforth,"ax"

.option push                # save option set 
.option norvc               # don't use compressed
.option norelax             # don't relax

.include "macros.inc"       # macros for everything
.include "user.inc"         # user area configuration 

STARTDICT

.include "dict_prims.inc" 
.include "dict_secs.inc"
#include "dict_appl.inc"    # include with cpp
.include "dict_env.inc"

ENDDICT

.option pop                 # restore option set

