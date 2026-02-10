# SPDX-License-Identifier: GPL-3.0-only

.include "core/config.inc"

/* TODO: this is made up, needs correcting */
.equ flash_page, 1*1024
.equ flash_cell, 4
.equ flash_erased, 0xFFFFFFFF /* a word in erased flash */
.equ flash_size, 256*1024
