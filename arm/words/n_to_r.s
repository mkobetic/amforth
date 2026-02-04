CODEWORD "n>r", N_TO_R /* ( xu .. x1 u -- ) (R: -- xu .. x1 u) move u items from data stack to return stack */
    mov r0, tos
    mov r1, tos
1:
    loadtos
    push {tos}
    subs r0,1
    bne 1b
    push {r1}
    loadtos
    NEXT
END N_TO_R
