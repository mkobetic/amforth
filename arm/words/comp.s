@
@    Mecrisp-Stellaris - A native code Forth implementation for ARM-Cortex M microcontrollers
@    Copyright (C) 2013  Matthias Koch
@
@    This program is free software: you can redistribute it and/or modify
@    it under the terms of the GNU General Public License as published by
@    the Free Software Foundation, either version 3 of the License, or
@    (at your option) any later version.
@
@    This program is distributed in the hope that it will be useful,
@    but WITHOUT ANY WARRANTY; without even the implied warranty of
@    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
@    GNU General Public License for more details.
@
@    You should have received a copy of the GNU General Public License
@    along with this program.  If not, see <http://www.gnu.org/licenses/>.
@

@ Comparison operators

@ -----------------------------------------------------------------------------
  CODEWORD  "0=", ZEROEQUAL /* ( n -- f ) f = n == 0 */
@ -----------------------------------------------------------------------------
  subs tos, #1
  sbcs tos, tos
  NEXT
END ZEROEQUAL

@ -----------------------------------------------------------------------------
  CODEWORD  "0<>", NOTZEROEQUAL /* ( n -- f ) f = n != 0 */
@ -----------------------------------------------------------------------------
  subs tos, #1
  sbcs tos, tos
  mvns tos, tos
  NEXT
END NOTZEROEQUAL

@ -----------------------------------------------------------------------------
  CODEWORD  "0<", ZEROLESS /* ( n -- f ) f = n < 0 */
@ -----------------------------------------------------------------------------
  movs tos, tos
  asr tos, #32    @ Turn MSB into 0xffffffff or 0x00000000
  NEXT
END ZEROLESS

@ -----------------------------------------------------------------------------
  CODEWORD  ">=", GREATEREQUAL /* ( n1 n2 -- f ) f = n1 >= n2 */
@ -----------------------------------------------------------------------------
  popnos r0     @ Get x1 into a register.
  cmp r0, tos        @ Is x2 less?
  ite lt             @ If so,
  movlt tos, #0      @  set all bits in TOS,
  movge tos, #-1     @  otherwise clear them all.
  NEXT
END GREATEREQUAL 

@ -----------------------------------------------------------------------------
  CODEWORD  "<=", LESSEQUAL /* ( n1 n2 -- f ) f = n1 <= n2 */
@ -----------------------------------------------------------------------------
  popnos r0     @ Get x1 into a register.
  cmp r0, tos        @ Is x2 greater?
  ite gt             @ If so,
  movgt tos, #0      @  set all bits in TOS,
  movle tos, #-1     @  otherwise clear them all.
  NEXT
END LESSEQUAL

@ -----------------------------------------------------------------------------
  CODEWORD  "<", LESS /* ( n1 n2 -- f ) f = n1 < n2 */
@ -----------------------------------------------------------------------------
  popnos r0     @ Get x1 into a register.
  cmp r0, tos        @ Is x2 less?
  ite lt             @ If so,
  movlt tos, #-1     @  set all bits in TOS,
  movge tos, #0      @  otherwise clear them all.
  NEXT
END LESS

@ -----------------------------------------------------------------------------
  CODEWORD  ">", GREATER /* ( n1 n2 -- f ) f = n1 > n2 */
@ -----------------------------------------------------------------------------
  popnos r0     @ Get x1 into a register.
  cmp r0, tos        @ Is x2 greater?
  ite gt             @ If so,
  movgt tos, #-1     @  set all bits in TOS,
  movle tos, #0      @  otherwise clear them all.
  NEXT
END GREATER

@ -----------------------------------------------------------------------------
  CODEWORD  "u<", ULESS /* ( u1 u2 -- f ) f = u1 < u2 */
@ -----------------------------------------------------------------------------
  popnos r0      @ Get u1 into a register.
  subs tos, r0, tos   @ subs tos, w, tos   @ TOS = a-b  -- carry set if a is less than b
  sbcs tos, tos
  NEXT
END ULESS

@ -----------------------------------------------------------------------------
  CODEWORD  "u>", UGREATER /* ( u1 u2 -- f ) f = u1 > u2 */
@ -----------------------------------------------------------------------------
  popnos r0
  subs tos, r0
  sbcs tos, tos
  NEXT
END UGREATER

@ -----------------------------------------------------------------------------
  CODEWORD  "<>", NOTEQUAL /* ( n1 n2 -- f ) f = n1 != n2 */
@ -----------------------------------------------------------------------------
  popnos r0      @ Get the next elt into a register.
  subs tos, r0        @ Z=equality; if equal, TOS=0

  it ne             @ If not equal,
  movne tos, #-1    @  set all bits in TOS.
  NEXT
END NOTEQUAL

@ -----------------------------------------------------------------------------
  CODEWORD  "=", EQUAL /* ( n1 n2 -- f ) f = n1 == n2 */
@ -----------------------------------------------------------------------------
  popnos r0     @ Get the next elt into a register.
  subs tos, r0       @ Z=equality; if equal, TOS=0

  subs tos, #1       @ Wenn es Null war, gibt es jetzt einen Überlauf
  sbcs tos, tos
  NEXT
END EQUAL

@ -----------------------------------------------------------------------------
  CODEWORD  "min", MIN /* ( n1 n2 -- n3 ) n3 = min(n1, n2) */
@ -----------------------------------------------------------------------------
  popnos r0       @ Get x1 into a register.
  cmp r0, tos          @ Compare them.
  it lt                @ If X is less,
  movlt tos, r0        @  replace TOS with it.
  NEXT
END MIN

@ -----------------------------------------------------------------------------
  CODEWORD  "max", MAX /* ( n1 n2 -- n3 ) n3 = max(n1, n2) */
@ -----------------------------------------------------------------------------
  popnos r0       @ Get x1 into a register.
  cmp r0, tos          @ Compare them.
  it gt                @ If X is greater,
  movgt tos, r0        @  replace TOS with it.
  NEXT
END MAX

@ -----------------------------------------------------------------------------
  CODEWORD  "umax", UMAX /* ( u1 u2 -- u3 ) u3 = max(u1, u2) */
@ -----------------------------------------------------------------------------
  popnos r0  @ Get u1 into a register.
  cmp r0, tos 
  it hi           @ If W > TOS,
  movhi tos, r0   @  replace TOS with W.
  NEXT
END UMAX

@ -----------------------------------------------------------------------------
  CODEWORD  "umin", UMIN /* ( u1 u2 -- u3 ) u3 = min(u1, u2) */
@ -----------------------------------------------------------------------------
  popnos r0  @ Get u1 into a register.
  cmp r0, tos
  it lo           @ If W < TOS,
  movlo tos, r0   @  replace TOS with W.
  NEXT
END UMIN

