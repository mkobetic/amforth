
VARIABLE "#tib", NUMBERTIB /* ( -- u ) u is number of characters stored in TIB */
END NUMBERTIB

CODEWORD "tib", TIB /* ( -- addr ) terminal input buffer address */
  savetos
  ldr tos, =RAM_lower_refill_buf
  NEXT
END TIB
