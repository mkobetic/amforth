/*
WORD: "um/mod"
STACK: ( ud u1 -- u2 u3 )
CATEG: CORE
SHORT: Divide ud by u1, giving the quotient u3 and the remainder u2.

All values and arithmetic are unsigned. Throw if u1 is zero or if the quotient u3 lies outside the range of a single-cell unsigned integer.
*/

COLON "um/mod", UMSLASHMOD
# ( dividend divisor -- reminder quotient )
    /* throw if divisor is zero */
    .word XT_DUP, XT_ZEROEQUAL, XT_DOCONDBRANCH, 1f
	.word XT_DOLITERAL, EDIVZ, XT_THROW /* throw division by zero */
    /* perform 64-bit ud/mod */
1:  .word XT_ZERO, XT_UDSLASHMOD 
    /* (rem:lo rem:hi quo:lo quo:hi) */
    .word XT_NOTZEROEQUAL, XT_DOCONDBRANCH, 2f /* check quotient overflow (quo:hi (tos) != 0) */
	.word XT_DOLITERAL, ERANGE, XT_THROW /* throw result out of range */
2:  .word XT_NIP /* drop rem:hi (nos); must be zero since divisor is 32-bit */
    .word XT_EXIT
