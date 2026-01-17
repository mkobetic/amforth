# SPDX-License-Identifier: GPL-3.0-only
  CODEWORD "!", STORE # ( n a -- ) MEM: Store n in memory address a 
  lw t0, 0(s4)
  sw t0, 0(s3)
  lw s3, 4(s4)
  addi s4, s4, 8
  NEXT

#   CODEWORD "(!)", BRASTORE # ( n a -- ) MEM: Store n in memory address a 
#   lw t0, 0(s4)
#   sw t0, 0(s3)
#   lw s3, 4(s4)
#   addi s4, s4, 8
#   NEXT

# COLON "!", STORE
# 	.word XT_MEMMODE
# 	.word XT_DOCONDBRANCH,STORE_0001 # if
#     .word XT_BANGI
# 	.word XT_DOBRANCH,STORE_0002
# STORE_0001: # else
#     .word XT_BRASTORE
# STORE_0002: # then
# 	.word XT_EXIT
