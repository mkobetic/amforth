
# Parameter notation

symbol      | meaning
----------- | ----------------------
n n1 n2 n3  | signed number, single cell
u u1 u2 u3  | unsigned number, single cell
d d1 d2 d3  | signed number, double cell
ud ud1 ud2  | unsigned number, double cell
x x1 x2 x3  | single cell
f f1 f2 f3  | logical flag, 0 is false, not 0 is true
a a1 a2 a3  | cell aligned address
ca ca1 ca2  | character aligned address
fa fa1 fa2  | cell aligned address in FLASH
xt xt1 xt2  | execution token (XT)
c c1 c2 c3  | character (byte)
s s1 s2 s3  | string = address length pair
i*x j*x     | some unknown number of cells
"name"      | name consumed from input buffer
"ccc"       | string consumed from input buffer
wid         | XT of a wordlist word
ffa         | flag field address
lfa         | link field address
nfa         | name field address
cfa         | code field address (same as XT)
pfa         | parameter field address
loop-sys


# Stack notation

notation    | stack
----------- | -------------------
( -- )      | parameter/data stack
(R: -- )    | return stack
(C: -- )    | control flow stack (data stack at compile time)
(L: -- )    | leave stack

# Other terminology

term        | meaning
----------- | -------------------
TOS         | top of stack
NOS         | next on stack
3OS, 4OS    | 3rd, 4th, ... on stack
