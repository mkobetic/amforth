
RAMALLOT refill_buf, refill_buf_size

VARIABLE "#tib", NUMBERTIB

CODEWORD "tib", TIB 
  savetos
  ldr tos, =RAM_lower_refill_buf
NEXT
