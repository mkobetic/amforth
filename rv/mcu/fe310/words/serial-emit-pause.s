COLON "serial-key-pause" , SERIAL_KEY_PAUSE
    .word XT_PAUSE,XT_SERIAL_KEYQ, XT_DOCONDBRANCH, PFA_SERIAL_KEY_PAUSE
    .word XT_SERIAL_KEY
    .word XT_EXIT
END SERIAL_KEY_PAUSE

COLON "serial-emit-pause" , SERIAL_EMIT_PAUSE # ( c -- ) SERIAL: emit c on serial connection or pause if unable  
    .word XT_PAUSE,XT_SERIAL_EMITQ, XT_DOCONDBRANCH, PFA_SERIAL_EMIT_PAUSE
    .word XT_SERIAL_EMIT
    .word XT_EXIT
END SERIAL_EMIT_PAUSE

# # -----------------------------------------------------------------------------
#   CODEWORD  "serial-emit?", SERIAL_EMITQ
# # -----------------------------------------------------------------------------
#    savetos
# #  li t0, UART0_TXDATA
# #  lw t0, 0(t0)
# #  srai t0, t0, 31  # Sign extend the "transmit FIFO full" bit
# #  xori s3, t0, -1  # Invert it

# # a fudge for the moment FIXME 
#   li s3, -1 

#   NEXT
