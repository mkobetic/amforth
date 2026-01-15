# -----------------------------------------------------------------------------
  CODEWORD  "xor", XOR # ( n2 n1 -- n2 ^ n1 ) LOGIC: TOS is bitwise NOS XOR TOS
                        # Combines the top two stack elements using bitwise exclusive-OR.
# -----------------------------------------------------------------------------
  lw t0, 0(s4)
  addi s4, s4, 4
  xor s3, t0, s3
  NEXT
