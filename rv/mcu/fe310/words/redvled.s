
.equ LED , 1 << 5             

CODEWORD "+led" , PLUSLED
     li a1 , GPIO_PORT
     li a0 , LED 
     amoor.w a2, a0 , 0(a1) # (a1)<-{ {a2<-(a1)} or a0}
NEXT            
END PLUSLED

CODEWORD "-led" , MINUSLED
     li a1 , GPIO_PORT
     li a0 , LED
     li a3 , -1
     xor a0 , a0, a3
     amoand.w a2, a0, 0(a1) # (a1)<-{ {a2<-(a1)} and a0}
NEXT
END MINUSLED

CODEWORD "led.init" , LED_INIT
     li a1 , GPIO_OUTPUT_EN
     li a0 , LED 
     amoor.w a2, a0 , 0(a1) # (a1)<-{ {a2<-(a1)} or a0}

     li a1 , GPIO_PORT
     li a0 , LED 
     amoor.w a2, a0 , 0(a1) # (a1)<-{ {a2<-(a1)} or a0}
NEXT
END LED_INIT
