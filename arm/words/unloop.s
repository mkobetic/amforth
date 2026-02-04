CODEWORD "unloop", UNLOOP /* (R: loop-sys -- ) remove loop-sys, exit the loop and continue execution after it */
  pop {rloopindex, rlooplimit}
  NEXT
END UNLOOP

