# SPDX-License-Identifier: GPL-3.0-only
CODEWORD "swap", SWAP # ( n2 n1 -- n1 n2 ) STACK: swap TOS and NOS 
  mv t0, s3
  lw s3, 0(s4)
  sw t0, 0(s4)
  NEXT
