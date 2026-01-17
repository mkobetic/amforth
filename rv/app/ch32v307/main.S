# SPDX-License-Identifier: GPL-3.0-only
# main.S

.option norvc               # no opportunistic use of compressed ... 
.option norelax             # instructions or other such optimisations 

.globl main

.include "config.inc"

main:                       # executed from startup.inc 

    #jal init                # initialisation code written in C with
    #jal myclock
    # jal init

    .if WANT_QEM_BUILD
        # no clock
    .else        
        jal HSE96               # asm xtal + pll setup 
    .endif                  

    .if WANT_203_BUILD
      # jal usb_init
    .endif

    .if WANT_C_BUILD
       jal init
    .endif

    j PFA_COLD              # start AmForth-RV 


