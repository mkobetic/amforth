# SPDX-License-Identifier: GPL-3.0-only
# -----------------------------------------------------------------------------
  CODEWORD "ashift", ASHIFT # ( x n -- x >> n  ) LOGIC: shift x right n places (sign fill)
# -----------------------------------------------------------------------------
  lw t0, 0(s4)
  addi s4, s4, 4
  sra s3, t0, s3
  NEXT
