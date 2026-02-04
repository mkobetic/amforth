# SPDX-License-Identifier: GPL-3.0-only

CODEWORD "i", I /* ( -- n) inner-most loop index */
    savetos
    add s3, s7, s8
    NEXT
END I
