# SPDX-License-Identifier: GPL-3.0-only

COLON "binary", BINARY
# ( -- ) SYSTEM: change to binary
    .word XT_TWO,XT_BASE,XT_STORE,XT_EXIT
