# SPDX-License-Identifier: GPL-3.0-only
CODEWORD "2r@", 2R_FETCH /* (R: x1 x2 -- x1 x2 )( -- x1 x2) copy 2 cells from return stack to stack */
  savetos
  lw s3, 4(s5)
  savetos
  lw s3, 0(s5)
  NEXT
END 2R_FETCH
