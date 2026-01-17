# SPDX-License-Identifier: GPL-3.0-only
# -----------------------------------------------------------------------------
  CODEWORD "abs", ABS # ( n1 -- |n1| ) MATHS: TOS becomes abs(TOS)
# -----------------------------------------------------------------------------
  srai t0, s3, 31 # Turn MSB into 0xffffffff or 0x00000000
  add s3, s3, t0
  xor s3, s3, t0
  NEXT
