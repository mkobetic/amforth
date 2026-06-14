ENVIRONMENT "board", BOARD
.if TARGET==REDFIVE
    STRING "sifive_e, Rev B"
.else      
    STRING "sifive_e"
.endif
.word XT_EXIT
END BOARD

