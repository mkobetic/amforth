.equ QSPIBASE , 0x10014000
.equ QSPIDIV  , QSPIBASE + 0 
            
CODEWORD  "qspidiv", QSPIDIV
  li t3, 0x02
  li t4, QSPIDIV 
  sw t3, 0(t4)
NEXT
END QSPIDIV

