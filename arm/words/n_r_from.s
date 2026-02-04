CODEWORD "nr>", N_R_FROM /* ( -- xu .. x1 u ) (R: xu .. x1 u -- ) move u items from return stack to data stack */
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
