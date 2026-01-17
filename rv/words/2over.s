# SPDX-License-Identifier: GPL-3.0-only
# -----------------------------------------------------------------------------
  CODEWORD "2over", 2OVER # ( 4 3 2 1 -- 4 3 2 1 4 3 ) STACK: as per stack pattern! 
# -----------------------------------------------------------------------------
  savetos
  lw s3, 12(s4)
  savetos
  lw s3, 12(s4)
  NEXT
