CODEWORD "nr>", N_R_FROM /* ( -- xn .. x1 n ) (R: xn .. x1 n -- ) move n items from return stack to data stack */
    pop {r1}
    mov r0, r1
    savetos
1:
    pop {tos}
    savetos
    subs r0,1
    bne 1b
    mov tos, r1
    NEXT
END N_R_FROM
