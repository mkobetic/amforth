# SPDX-License-Identifier: GPL-3.0-only


# -----------------------------------------------------------------------------
  CODEWORD  "depth", DEPTH # ( -- Zahl der Elemente, die vorher auf den Datenstack waren )
                                  # ( -- Number of elements that have been on datastack before )
# -----------------------------------------------------------------------------
  # Berechne den Stackfüllstand
  la t0, RAM_upper_datastack # Anfang laden  Calculate stack fill gauge
  sub t0, t0, s4            # und aktuellen Stackpointer abziehen
  savetos
  srai s3, t0, 2 # Durch 4 teilen  Divide through 4 Bytes/element.
  NEXT

# -----------------------------------------------------------------------------
  CODEWORD  "rdepth", RDEPTH
# -----------------------------------------------------------------------------
  # Berechne den Stackfüllstand
  la t0, RAM_upper_returnstack # Anfang laden  Calculate stack fill gauge
  sub t0, t0, s5          # und aktuellen Stackpointer abziehen
  savetos
  srai s3, t0, 2 # Durch 4 teilen  Divide through 4 Bytes/element.
  NEXT


#------------------------------------------------------------------------------
  CODEWORD  "rdrop", RDROP # Entfernt das oberste Element des Returnstacks
#------------------------------------------------------------------------------
  addi s5, s5, 4
  NEXT
