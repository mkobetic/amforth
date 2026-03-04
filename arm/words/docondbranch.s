HEADLESS "(?branch)", DOCONDBRANCH /* ( f -- ) if f is false jump to address in next cell, otherwise continue after it */
    mov r0, tos
    loadtos
    cmp r0, #0
    beq PFA_DOBRANCH
    adds FORTHIP, #4
    NEXT
END DOCONDBRANCH
