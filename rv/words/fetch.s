# SPDX-License-Identifier: GPL-3.0-only
  CODEWORD "@", FETCH # ( a -- n ) MEM: TOS becomes contents of address a 
  lw s3, 0(s3)
  NEXT
