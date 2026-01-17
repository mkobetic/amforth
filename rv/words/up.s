# SPDX-License-Identifier: GPL-3.0-only

CODEWORD "up@", UP_FETCH
    savetos
    mv s3, s6
    NEXT

CODEWORD "up!", UP_STORE
    mv s6,s3
    loadtos
    NEXT

