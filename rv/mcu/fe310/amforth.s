# This is a template to start from.
# Copy it into your mcu/ directory and modify as needed.

.text

.include "mcu/qemu/config.inc"   # most configuration options are in this file
.include "build-config.inc"

.print "INFO: using FE310 startup"		
.include "fe310.startup"  # startup and master_int handler for both C and Forth

.section amforth, "ax"

.option push                # save option set 
.option norvc               # don't use compressed
.option norelax             # don't relax

.include "config.inc"
.include "build-config.inc"
.include "rv/macros.inc"
.include "user.inc"

STARTDICT

.include "dict_prims.inc"
.include "dict_secs.inc"
.include "dict_env.inc"
.include "dict_mcu.inc"

ENDDICT

.option pop                 # restore option set
