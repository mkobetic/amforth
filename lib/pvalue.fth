
\ A test script demonstrating the pvalue functionality
: pvto ( x "name" -- ) \ set value to x and write pvalue record for it
    vaddr pvstore ;

hex

\ Make sure arenas are "erased" to the expected blank flash state
pvarena1 pvarena.erase
pvarena1 10 - 5 dump \ check arena1
pvarena2 pvarena.erase
pvarena2 10 - 5 dump \ check arena2

\ show initial setup
pv.init
pvp .
pvarena .
pvarena 10 - 5 dump

\ update pvalues multiple times
vaddr pv1 . \ RAM address of pv1
pv1 .       \ value of pv1
1 pvto pv1
pv1 .
2 pvto pv1
pv1 .

vaddr pv2 . \ RAM address of pv2
pv2 .       \ value of pv1
3 pvto pv2
pv2 .

4 pvto pv1
pv1 .

5 pvto pv2
pv2 .

pvarena 10 - 5 dump \ show the arena
pvp .

\ reset the values and pvp
0 is pvp
0 vaddr pv1 !
pv1 .

0 vaddr pv2 !
pv2 .


pv.init \ reinitialize pvalue system
pv1 .
pv2 .
pv3 .
pvp .

\ swap arenas
pvarena.swap
pvp .
pvarena .
pvarena 10 - 5 dump \ show the new arena
pvarena.dormant 10 - 5 dump \ show the old arena