# SPDX-License-Identifier: GPL-3.0-only
VARIABLE "debug" , DEBUG /* debug flag for || */
END DEBUG


IMMED "||", BARBAR /* ( -- ) code after || is ignored during compilation if [debug] == 0 */
/* : || debug @ 0= if postpone \ then ; immediate  */
    .word XT_DEBUG
    .word XT_FETCH
    .word XT_ZEROEQUAL
    .word XT_DOCONDBRANCH , BARBAR1 
    .word XT_BACKSLASH
BARBAR1:    
    .word XT_EXIT
END BARBAR
