# This file contains steps that are executed early in the assembly structure,
# before words definitions are compiled.
# Code here should pertain to general AmForth32 architecture only.

# Allocate core system RAM areas: stacks, tib, user areas, ...
# TODO: should this be configurable?
RAMALLOT ram_vector, 256*cellsize, 4
RAMALLOT datastack, datastack_size, 4
RAMALLOT returnstack, returnstack_size, 4
RAMALLOT leavestack, leavestack_size, 4
RAMALLOT userarea, userarea_size
RAMALLOT refill_buf, refill_buf_size, 4

# EXCEPTION CODES

# Standard Exceptions
# https://forth-standard.org/standard/exception (Table 9.1)
.equ EABRT,    -1	/* ABORT */
.equ EABRTQ,   -2	/* ABORT" */
.equ EDSOVR,   -3	/* stack overflow */
.equ EDSUND,   -4	/* stack underflow */
.equ ERSOVR,   -5	/* return stack overflow */
.equ ERSUND,   -6	/* return stack underflow */
.equ ELOOPD,   -7	/* do-loops nested too deeply during execution */
.equ EDCOVR,   -8	/* dictionary overflow */
.equ EADRINV,  -9	/* invalid memory address */
.equ EDIVZ,    -10	/* division by zero */
.equ ERANGE,   -11	/* result out of range */
.equ EARGT,    -12	/* argument type mismatch */
.equ EUNDEF,   -13	/* undefined word */
.equ ECOMPO,   -14	/* interpreting a compile-only word */
.equ EFRGET,   -15	/* invalid FORGET */
.equ ENMEMP,   -16	/* attempt to use zero-length string as a name */
.equ ENUMOVR,  -17	/* pictured numeric output string overflow */
.equ EPAROVR,  -18	/* parsed string overflow */
.equ ENMLONG,  -19	/* definition name too long */
.equ EROWRT,   -20	/* write to a read-only location */
.equ EUNSUP,   -21	/* unsupported operation */
.equ ECTRL,    -22	/* control structure mismatch */
.equ EADRAL,   -23	/* address alignment exception */
.equ EARGN,    -24	/* invalid numeric argument */
.equ ERSIMB,   -25	/* return stack imbalance */
.equ ELOOPP,   -26	/* loop parameters unavailable */
.equ ERECUR,   -27	/* invalid recursion */
.equ EUINT,    -28	/* user interrupt */
.equ ECOMPN,   -29	/* compiler nesting */
.equ EOBSOL,   -30	/* obsolescent feature */
.equ EBODY,    -31	/* >BODY used on non-CREATEd definition */
.equ ENMINV,   -32	/* invalid name argument (e.g., TO name) */

.equ EWLDEL,   -47	/* compilation word list deleted */
.equ EPOSTP,   -48	/* invalid POSTPONE */
.equ ESOOVL,   -49	/* search-order overflow */
.equ ESOUND,   -50	/* search-order underflow */
.equ EWLCHG,   -51	/* compilation word list changed */
.equ ECSOVR,   -52	/* control-flow stack overflow */
.equ EESOVR,   -53	/* exception stack overflow */
