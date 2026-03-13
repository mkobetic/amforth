#======================================================================
#======================================================================
# transpiling xt2string.f on 2026/03/13 12:16:20
# \ # SPDX-License-Identifier: GPL-3.0-only
# 
# : xt>string \# ( xt c-addr u ) leave string associated with name of xt
# {
# /*
# xt>string always returns a valid string. If xt>nfa leaves a zero NFA
# (indicating a failure to find a valid NFA ) then xt>string leaves
# "" Similarly, if a valid NFA is found and the dictionary backcheck
# fails then "" is again left. If xt>nfa indicates that a NONAME or
# HEADLESS word was found, this is compile-time optionally checked against
# a select list of NONAME and HEADLESS words and their name returned if
# found or "nn|hl" if not
# */
# }
# 
#     >r r@ xt>nfa 0= if s" " rdrop exit then
# 
#     r@ xt>nfa dup @ 3 <> if
#         dup count find-xt if drop count else drop s" " rdrop exit then
#     else
#         drop
#         { .ifnb  YES }
#         r@ case
#            symbol XT_DOBRANCH      of s" (branch)" endof
#            symbol XT_DOCONDBRANCH  of s" (?branch)" endof
#            symbol XT_LMARK         of s" <mark" endof
#            symbol XT_GMARK         of s" mark>" endof
#            symbol XT_LRESOLVE      of s" <resolve" endof
#            symbol XT_GRESOLVE      of s" resolve>" endof
#            symbol XT_DOTO          of s" (to)" endof
#            symbol XT_FLASHDOTFLUSH of s" flash.flush" endof
#            symbol XT_DOLITERAL     of s" (literal)" endof
#            symbol XT_DOXLITERAL    of s" (xliteral)" endof
#            symbol XT_DODO          of s" (do)" endof
#            symbol XT_DOLOOP        of s" (loop)" endof
#            symbol XT_DOPLUSLOOP    of s" (+loop)" endof
#            drop s" nn|hl" false
#        endcase
#        { .else }
#        s" nn|hl"
#        { .endif }
#    then
#    rdrop
# ;
# 

# ----------------------------------------------------------------------
COLON "xt>string", XT2STRING /* ( xt c-addr u ) leave string associated with name of xt */
/*
xt>string always returns a valid string. If xt>nfa leaves a zero NFA
(indicating a failure to find a valid NFA ) then xt>string leaves
"" Similarly, if a valid NFA is found and the dictionary backcheck
fails then "" is again left. If xt>nfa indicates that a NONAME or
HEADLESS word was found, this is compile-time optionally checked against
a select list of NONAME and HEADLESS words and their name returned if
found or "nn|hl" if not
*/
	.word XT_TO_R
	.word XT_R_FETCH
	.word XT_XT2NFA
	.word XT_ZEROEQUAL
	.word XT_DOCONDBRANCH,XT2STRING_0001 /* if */
	STRING ""
	.word XT_RDROP
	.word XT_FINISH
XT2STRING_0001: /* then */
	.word XT_R_FETCH
	.word XT_XT2NFA
	.word XT_DUP
	.word XT_FETCH
	.word XT_DOLITERAL
	.word 3
	.word XT_NOTEQUAL
	.word XT_DOCONDBRANCH,XT2STRING_0002 /* if */
	.word XT_DUP
	.word XT_COUNT
	.word XT_FINDXT
	.word XT_DOCONDBRANCH,XT2STRING_0003 /* if */
	.word XT_DROP
	.word XT_COUNT
	.word XT_DOBRANCH,XT2STRING_0004
XT2STRING_0003: /* else */
	.word XT_DROP
	STRING ""
	.word XT_RDROP
	.word XT_FINISH
XT2STRING_0004: /* then */
	.word XT_DOBRANCH,XT2STRING_0005
XT2STRING_0002: /* else */
	.word XT_DROP
.ifnb YES
	.word XT_R_FETCH
	.word XT_DOLITERAL
	.word XT_DOBRANCH
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,XT2STRING_0006 /* if */
	.word XT_DROP
	STRING "(branch)"
	.word XT_DOBRANCH,XT2STRING_0007
XT2STRING_0006: /* else */
	.word XT_DOLITERAL
	.word XT_DOCONDBRANCH
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,XT2STRING_0008 /* if */
	.word XT_DROP
	STRING "(?branch)"
	.word XT_DOBRANCH,XT2STRING_0009
XT2STRING_0008: /* else */
	.word XT_DOLITERAL
	.word XT_LMARK
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,XT2STRING_000A /* if */
	.word XT_DROP
	STRING "<mark"
	.word XT_DOBRANCH,XT2STRING_000B
XT2STRING_000A: /* else */
	.word XT_DOLITERAL
	.word XT_GMARK
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,XT2STRING_000C /* if */
	.word XT_DROP
	STRING "mark>"
	.word XT_DOBRANCH,XT2STRING_000D
XT2STRING_000C: /* else */
	.word XT_DOLITERAL
	.word XT_LRESOLVE
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,XT2STRING_000E /* if */
	.word XT_DROP
	STRING "<resolve"
	.word XT_DOBRANCH,XT2STRING_000F
XT2STRING_000E: /* else */
	.word XT_DOLITERAL
	.word XT_GRESOLVE
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,XT2STRING_0010 /* if */
	.word XT_DROP
	STRING "resolve>"
	.word XT_DOBRANCH,XT2STRING_0011
XT2STRING_0010: /* else */
	.word XT_DOLITERAL
	.word XT_DOTO
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,XT2STRING_0012 /* if */
	.word XT_DROP
	STRING "(to)"
	.word XT_DOBRANCH,XT2STRING_0013
XT2STRING_0012: /* else */
	.word XT_DOLITERAL
	.word XT_FLASHDOTFLUSH
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,XT2STRING_0014 /* if */
	.word XT_DROP
	STRING "flash.flush"
	.word XT_DOBRANCH,XT2STRING_0015
XT2STRING_0014: /* else */
	.word XT_DOLITERAL
	.word XT_DOLITERAL
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,XT2STRING_0016 /* if */
	.word XT_DROP
	STRING "(literal)"
	.word XT_DOBRANCH,XT2STRING_0017
XT2STRING_0016: /* else */
	.word XT_DOLITERAL
	.word XT_DOXLITERAL
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,XT2STRING_0018 /* if */
	.word XT_DROP
	STRING "(xliteral)"
	.word XT_DOBRANCH,XT2STRING_0019
XT2STRING_0018: /* else */
	.word XT_DOLITERAL
	.word XT_DODO
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,XT2STRING_001A /* if */
	.word XT_DROP
	STRING "(do)"
	.word XT_DOBRANCH,XT2STRING_001B
XT2STRING_001A: /* else */
	.word XT_DOLITERAL
	.word XT_DOLOOP
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,XT2STRING_001C /* if */
	.word XT_DROP
	STRING "(loop)"
	.word XT_DOBRANCH,XT2STRING_001D
XT2STRING_001C: /* else */
	.word XT_DOLITERAL
	.word XT_DOPLUSLOOP
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,XT2STRING_001E /* if */
	.word XT_DROP
	STRING "(+loop)"
	.word XT_DOBRANCH,XT2STRING_001F
XT2STRING_001E: /* else */
	.word XT_DROP
	STRING "nn|hl"
	.word XT_FALSE
	.word XT_DROP
XT2STRING_001F: /* then */
XT2STRING_001D: /* then */
XT2STRING_001B: /* then */
XT2STRING_0019: /* then */
XT2STRING_0017: /* then */
XT2STRING_0015: /* then */
XT2STRING_0013: /* then */
XT2STRING_0011: /* then */
XT2STRING_000F: /* then */
XT2STRING_000D: /* then */
XT2STRING_000B: /* then */
XT2STRING_0009: /* then */
XT2STRING_0007: /* then */
.else
	STRING "nn|hl"
.endif
XT2STRING_0005: /* then */
	.word XT_RDROP
	.word XT_EXIT
END XT2STRING
# ----------------------------------------------------------------------
#=====================================================================
#======================================================================
