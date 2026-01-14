# SPDX-License-Identifier: GPL-3.0-only
#======================================================================
#======================================================================
#     search.f does NOT transpile as of Mon 14 Oct 24 17:19:41
#     major hacking is required to fix it. The closing 'then' confuses
#     the living daylight out of my poor brain dead program.  

# : search  \# ( c-a1 u1 c-a2 u2 -- c-a3 u3 f) STRING: find s1 in s2 leaving flag and tail s 
#     begin
#         dup
#     while
#             2over 3 pick over compare
#             while
#                     1 /string
#             repeat
#         2nip true exit
#     then 
#     2drop false
# ;


# ----------------------------------------------------------------------
COLON "search", SEARCH
# ( s1 s2 -- s3 f) STRING: find s1 in s2 leaving flag and tail s3 
SEARCH_0001: # begin
	.word XT_DUP
	.word XT_DOCONDBRANCH,SEARCH_0002 /* while */
	.word XT_2OVER
	.word XT_DOLITERAL
	.word 3
	.word XT_PICK
	.word XT_OVER
	.word XT_COMPARE
	.word XT_DOCONDBRANCH,SEARCH_0003 /* while */
	.word XT_ONE
	.word XT_SLASHSTRING
	.word XT_DOBRANCH,SEARCH_0001 /* repeat */
SEARCH_0003:
	.word XT_2NIP
	.word XT_TRUE
	.word XT_FINISH
SEARCH_0002: # then
	.word XT_2DROP
	.word XT_FALSE
	.word XT_EXIT
# ----------------------------------------------------------------------
COLON "sub-string?", SUBMINUSSTRINGQ
# ( s1 s2 -- f ) STRING: f is true if s1 found in s2
	.word XT_SEARCH
	.word XT_NIP
	.word XT_NIP
	.word XT_EXIT
# ----------------------------------------------------------------------
#=====================================================================
#======================================================================
