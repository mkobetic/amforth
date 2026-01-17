# SPDX-License-Identifier: GPL-3.0-only
# options

.equ YES , 1
.equ NO  , 0 

# the big choices - but only half of it. The Makefile must have
# the equivalent defines set too. No easy way to do it from here.

# Choose the target for the build. Exactly ONE of these
# options should be YES, all others should be NO

.equ WANT_307_BUILD    , NO
.equ WANT_305_BUILD    , NO
.equ WANT_203_BUILD    , NO
.equ WANT_QEM_BUILD    , YES

# Choose NO if you want to include C code in the lib_???_user dir 

.equ WANT_ASM_BUILD    , YES


.equ WANT_IGNORECASE   , YES  
.equ WANT_NESTED_ISR   , NO

# if WANT_ASM_BUILD is YES the USB options will be ignored 

.equ WANT_USB_OPERATOR , NO   # if YES - USB prompt if NO serial prompt
.equ WANT_USB          , NO   # if YES - USB code included 

# if WANT_ASM_BUILD is YES the FLOAT option will be ignored

.equ WANT_FLOAT        , NO

# what Forth word groups do you want included in the core 

.equ WANT_CASE         , NO
.equ WANT_MATCH        , NO
.equ WANT_FORNEXT      , NO

.equ WANT_SEE          , NO
.equ WANT_SAVE         , NO

.equ WANT_TIMER6       , NO
.equ WANT_SYSTICK      , NO

.equ WANT_PORTD        , NO
.equ WANT_PORTC        , YES 
.equ WANT_PORTB        , YES
.equ WANT_PORTA        , YES

.equ WANT_CODE         , NO
.equ WANT_TABLE        , NO

.equ WANT_SEARCH_ORDER , YES 

# ----------------------------------------------------------------------
# generate some pure GAS abolute expressions as a consequence of above 

# -- GAS .if can only handle absolute expressions and I don't want CPP

.if WANT_ASM_BUILD
    .equ WANT_C_BUILD      , NO
    .equ WANT_USB_OPERATOR , NO
    .equ WANT_USB          , NO
    .equ WANT_FLOAT        , NO
.else
    .equ WANT_C_BUILD , YES
.endif            

# -- if you WANT_USB_OPERATOR you WANT_USB

.if WANT_USB_OPERATOR
    .equ WANT_USB     , YES
.endif         

.if WANT_SEE
    .equ WANT_CASE    , YES
    .equ WANT_MATCH   , YES
.endif

.if WANT_SAVE
    .equ WANT_CASE    , YES
    .equ WANT_MATCH   , YES
.endif


# currently cellsize needs to be 4. One day
# it will be a configuration variable. 

.equ cellsize , 4 
