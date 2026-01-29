# SPDX-License-Identifier: GPL-3.0-only
  CODEWORD "@", FETCH # ( a -- n ) MEM: TOS becomes contents of address a 

    andi t0, s3, 0x3       /* cell aligned ?        */
    beqz t0, 1f            /* branch if OK          */

    /* handle exception ...                         */

    throw -9 

1:  /* normal operation ...                         */

    lw s3, 0(s3)
    
  NEXT
