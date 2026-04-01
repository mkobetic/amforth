\ Interrupt Controller Type Register, ICTR
\ INTLINESNUM, bits[3:0]
\   The total number of interrupt lines supported by an implementation, defined in groups of
\   32. That is, the total number of interrupt lines is up to (32*(INTLINESNUM+1)).
\   However,the absolute maximum number of interrupts is 496
$E000E004
