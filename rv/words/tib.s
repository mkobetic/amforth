# SPDX-License-Identifier: GPL-3.0-only
# -----------------------------------------------------------------------------
  CODEWORD "tib", TIB # ( -- addr )
# -----------------------------------------------------------------------------
  savetos
  la s3, RAM_lower_refill_buf
  NEXT

VARIABLE "#tib", NUMBERTIB

