# SPDX-License-Identifier: GPL-3.0-only
COLON "defer@", DEFER_FETCH
	.word XT_CELLPLUS
	.word XT_FETCH
	.word XT_FETCH
	.word XT_EXIT

# COLON "defer@", DEFERFETCH
#     .word XT_TO_BODY
#     .word XT_DUP, XT_FETCH,XT_SWAP
#     .word XT_CELLPLUS
#     .word XT_CELLPLUS
#     .word XT_FETCH
#     .word XT_EXECUTE
#     .word XT_EXIT
