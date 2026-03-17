# SPDX-License-Identifier: GPL-3.0-only

DEFER "refill", REFILL, XT_REFILLTIB /* ( -- f ) refills the input buffer */
END REFILL

CONSTANT "refill-buf-size", REFILL_BUF_SIZE, refill_buf_size
END REFILL_BUF_SIZE

COLON "refill-tib", REFILLTIB /* ( -- f ) refills the input buffer */
    .word XT_TIB
    .word XT_DOLITERAL
    .word refill_buf_size
    .word XT_ACCEPT
    .word XT_NUMBERTIB
    .word XT_STORE
    .word XT_ZERO
    .word XT_TO_IN
    .word XT_STORE
    .word XT_TRUE 
    .word XT_EXIT
END REFILLTIB
