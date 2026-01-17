# SPDX-License-Identifier: GPL-3.0-only
  CODEWORD "2r@", 2RFETCH # ( -- 2 1 R: 2 1 -- 2 1 )
  savetos
  lw s3, 4(s5)
  savetos
  lw s3, 0(s5)
  NEXT
