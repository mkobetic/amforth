

# Common Anode tied to Vcc. LEDs shine on low.
.equ green, 1<<19 # GPIO 19: Green LED
.equ blue,  1<<21 # GPIO 21: Blue LED
.equ red,   1<<22 # GPIO 22: Red LED

CODEWORD  "led-init", LED_INIT
  li t3, red|green|blue
  li t4, GPIO_OUTPUT_EN
  sw t3, 0(t4)
  li t3, red|green|blue
  li t4, GPIO_PORT
  sw t3, 0(t4)
NEXT
END LED_INIT

CODEWORD  "red", RED
    li t3, blue|green
    li t4, GPIO_PORT
    sw t3, 0(t4)
NEXT
END RED

CODEWORD  "green", GREEN
    li t3, blue|red
    li t4, GPIO_PORT
    sw t3, 0(t4)
NEXT
END GREEN

CODEWORD  "blue", BLUE
    li t3, red|green
    li t4, GPIO_PORT
    sw t3, 0(t4)
NEXT
END BLUE

CODEWORD  "white", WHITE
    li t3, 0
    li t4, GPIO_PORT
    sw t3, 0(t4)
NEXT
END WHITE

CODEWORD  "yellow", YELLOW
    li t3, blue
    li t4, GPIO_PORT
    sw t3, 0(t4)
NEXT
END YELLOW

CODEWORD  "cyan", CYAN
    li t3, red
    li t4, GPIO_PORT
    sw t3, 0(t4)
NEXT
END CYAN

CODEWORD  "magenta", MAGENTA
    li t3, green
    li t4, GPIO_PORT
    sw t3, 0(t4)
NEXT
END MAGENTA

CODEWORD  "black", BLACK
    li t3, red|green|blue
    li t4, GPIO_PORT
    sw t3, 0(t4)
NEXT
END BLACK

