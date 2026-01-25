# Default AmForth 32-bit configuration
# MCUs should import this and override as needed

# Fundamentals
# Note: .global is needed to allow linker to use the constant.

.equ cellsize, 4
.global cellsize

# RAMLO areas

.equ datastack_size, 40 * cellsize
.global datastack_size

.equ returnstack_size, 40 * cellsize
.global returnstack_size

.equ leavestack_size, 8 * cellsize
.global leavestack_size

.equ refill_buf_size, 96
.global refill_buf_size

.equ userarea_size, (2 + 32) * cellsize
.global userarea_size

# RAMHI areas

.equ rampool_size, 4096*2
.global rampool_size

# Feature flags

.equ YES , 1
.equ NO  , 0

# what Forth word groups do you want included in the core
.equ WANT_SEARCH_ORDER , YES 
.equ WANT_FLOAT , NO

.equ WANT_CASE         , NO
.equ WANT_MATCH        , NO
.equ WANT_FORNEXT      , NO

.equ WANT_SEE          , NO
.equ WANT_SAVE         , NO

.equ WANT_CODE         , NO
.equ WANT_TABLE        , NO

# Other configuration parameters
.equ WANT_USB_OPERATOR , NO
.if WANT_USB_OPERATOR
.ifdef BUILD_QEM
.error "Cannot use WANT_USB_OPERATOR with QEM target"
.endif
.endif

# This can also be enabled with an environment variable with the same name
# .equ WANT_IGNORECASE, YES
