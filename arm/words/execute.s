
CODEWORD "execute", EXECUTE /* ( xt -- ) execute XT at the top of the stack */
    mov FORTHW, tos
    loadtos
    b DO_EXECUTE
END EXECUTE
