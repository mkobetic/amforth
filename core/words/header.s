# SPDX-License-Identifier: GPL-3.0-only
# MFD VALUE "header.flag" , HEADERDOTFLAG, 0x33

COLON "header", HEADER /* ( addr u wid -- ffa ) creates header (without CF/PF) for name at addr, in wordlist wid */
    .word XT_DALIGN
    .word XT_OVER,XT_GREATERZERO 
    .word XT_DOCONDBRANCH, PFA_HEADER1
    .word XT_EXECUTE /* executing wid returns ffa of the last word */
    .word XT_COMMA
    .word XT_DP,XT_TO_R
# original
#    .word XT_DOLITERAL
#    .word Flag_visible
# new
    .word XT_FLAGDOTHEADER
    .word XT_COMMA
    .word XT_SCOMMA
    .word XT_R_FROM /* return the FFA */
    .word XT_EXIT

PFA_HEADER1:
    .word XT_DOLITERAL
    .word -16
    .word XT_THROW
END HEADER
