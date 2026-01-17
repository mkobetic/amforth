# SPDX-License-Identifier: GPL-3.0-only

CODEWORD "pc", PC # ( n -- n ) 
  savetos
  auipc s3,0
  NEXT
