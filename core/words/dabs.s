# SPDX-License-Identifier: GPL-3.0-only
COLON "dabs", DABS
  .word XT_DUP,XT_ZEROLESS, XT_DOCONDBRANCH,DABS_LEAVE
    .word XT_DNEGATE
DABS_LEAVE:
  .word XT_EXIT

