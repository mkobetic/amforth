# Scavenge the list of files in build/amforth.dep and
# spit out the headers of all the words encountered.
# Along the way attach the file:line location to each.

# match($0, /COLON[[:space:]]+".*",/) { print substr($0, RSTART + 7, RLENGTH - 9) }
/CODEWORD[[:space:]]+".*"/ { $1=$1; print $0 " @ " FILENAME ":" FNR }
/CODEALIAS[[:space:]]+".*"/ { $1=$1; print $0 " @ " FILENAME ":" FNR }
/HEADLESS[[:space:]]+".*"/ { $1=$1; print $0 " @ " FILENAME ":" FNR }
/HIDEWORD[[:space:]]+".*"/ { $1=$1; print $0 " @ " FILENAME ":" FNR }
/COLON[[:space:]]+".*"/ { $1=$1; print $0 " @ " FILENAME ":" FNR }
/NONAME[[:space:]]+".*"/ { $1=$1; print $0 " @ " FILENAME ":" FNR }
/IMMED[[:space:]]+".*"/ { $1=$1; print $0 " @ " FILENAME ":" FNR }
/VARIABLE[[:space:]]+".*"/ { $1=$1; print $0 " @ " FILENAME ":" FNR }
/DVARIABLE[[:space:]]+".*"/ { $1=$1; print $0 " @ " FILENAME ":" FNR }
/NVARIABLE[[:space:]]+".*"/ { $1=$1; print $0 " @ " FILENAME ":" FNR }
/USER[[:space:]]+".*"/ { $1=$1; print $0 " @ " FILENAME ":" FNR }
/VALUE[[:space:]]+".*"/ { $1=$1; print $0 " @ " FILENAME ":" FNR }
/DEFER[[:space:]]+".*"/ { $1=$1; print $0 " @ " FILENAME ":" FNR }
/UDEFER[[:space:]]+".*"/ { $1=$1; print $0 " @ " FILENAME ":" FNR }
/CONSTANT[[:space:]]+".*"/ { $1=$1; print $0 " @ " FILENAME ":" FNR }
/CON[[:space:]]+".*"/ { $1=$1; print $0 " @ " FILENAME ":" FNR }
/DATA[[:space:]]+".*"/ { $1=$1; print $0 " @ " FILENAME ":" FNR }
/ENVINRONMENT[[:space:]]+".*"/ { $1=$1; print $0 " @ " FILENAME ":" FNR }
# RISC-V
/CSR[[:space:]]+".*"/ { $1=$1; print $0 " @ " FILENAME ":" FNR }
# ARM
/ARM_COLON[[:space:]]+".*"/ { $1=$1; print $0 " @ " FILENAME ":" FNR }
/ARM_CONSTANT[[:space:]]+".*"/ { $1=$1; print $0 " @ " FILENAME ":" FNR }
