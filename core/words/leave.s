# SPDX-License-Identifier: GPL-3.0-only

VALUE "lp0", LP0, RAM_upper_leavestack /* start of the leave stack */
END LP0

VARIABLE "lp", LP /* leave stack pointer */
END LP

COLON "l>", L_FROM /* ( -- x ) (L: x -- ) move TOL to TOS */
    .word XT_LP
    .word XT_FETCH
    .word XT_FETCH
    .word XT_DOLITERAL
    .word 4
    .word XT_LP
    .word XT_PLUSSTORE
    .word XT_EXIT
END L_FROM

COLON ">l", TO_L /* ( x -- )(L: -- x ) move TOS to TOL */
    .word XT_DOLITERAL,-4
    .word XT_LP
    .word XT_PLUSSTORE
    .word XT_LP
    .word XT_FETCH
    .word XT_STORE
    .word XT_EXIT
END TO_L

IMMED "leave", LEAVE /* ( -- )(R: loop-sys -- ) immediately leave the current DO..LOOP */
    .word XT_COMPILE,XT_UNLOOP
    .word XT_AHEAD,XT_TO_L,XT_EXIT
END LEAVE
