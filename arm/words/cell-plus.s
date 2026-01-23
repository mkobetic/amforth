CODEWORD "cell+", CELLPLUS @ ( x -- x+4 ) 
  add tos, #cellsize
NEXT

# -----------------------------------------------------------------------------
  CODEWORD "char+", CHARPLUS @ ( x -- x+1 ) STACK: Add one to TOS
# -----------------------------------------------------------------------------
  add tos, #1 
NEXT
