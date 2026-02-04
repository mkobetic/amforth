CODEWORD "(exit)", EXIT /* (R: addr -- ) loads addr into IP; compiled by semicolon */
  pop {FORTHIP}
  NEXT
END EXIT

CODEWORD "exit", FINISH /* (R: addr -- ) loads addr into IP; compiled by exit */
  pop {FORTHIP}
  NEXT
END FINISH
