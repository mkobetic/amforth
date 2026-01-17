# SPDX-License-Identifier: GPL-3.0-only

#CODEWORD "exit", EXIT
#  pop s2   # IP
#  NEXT

# this is the xt that will be added by semicolon 
CODEWORD "(exit)", EXIT 
  pop s2   # IP
  NEXT

# this is the xt that will be added by exit
CODEWORD "exit", FINISH # ( -- ) FLOW: exit word (instantly) 
  pop s2   # IP
  NEXT

