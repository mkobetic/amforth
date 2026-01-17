# SPDX-License-Identifier: GPL-3.0-only

IMMED "(", LPAREN
# ( -- ) SYSTEM: Start of ( .... ) comment  
    .word XT_DOLITERAL, 0x29
    .word XT_PARSE
    .word XT_2DROP
    .word XT_EXIT
