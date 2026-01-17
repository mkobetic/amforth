# SPDX-License-Identifier: GPL-3.0-only

COLON "hex", HEX
# ( -- ) SYSTEM: change base to hexadecimal
.word XT_DOLITERAL,16,XT_BASE,XT_STORE,XT_EXIT
