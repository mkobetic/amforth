# SPDX-License-Identifier: GPL-3.0-only
# -----------------------------------------------------------------------------
  CODEWORD "um+", UMPLUS # ( n2 n1 -- n2+n1 carry ) MATHS: unsigned addtion with carry  
# -----------------------------------------------------------------------------
  lw   t0, 0(s4)
  add  s3, s3, t0
  sw   s3, 0(s4)
  sltu s3, s3, t0
  NEXT
