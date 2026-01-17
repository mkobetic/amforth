# SPDX-License-Identifier: GPL-3.0-only

COLON "decimal", DECIMAL
# ( -- ) SYSTEM: change base to decimal
.word XT_DOLITERAL,10,XT_BASE,XT_STORE,XT_EXIT
