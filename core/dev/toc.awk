# Scavenge the list of files in build/amforth.dep and
# spit out the headers of all the words encountered.
# Along the way attach the file:line location to each.

# match($0, /COLON ".*",/) { print substr($0, RSTART + 7, RLENGTH - 9) }
FNR == 1 { FN = (FILENAME ~ /^\//) ? FILENAME : ENVIRON["PWD"] "/" FILENAME }
/CODEWORD ".*"/ { $1=$1; print $0 " @ " FN ":" FNR }
/CODEALIAS ".*"/ { $1=$1; print $0 " @ " FN ":" FNR }
/HEADLESS ".*"/ { $1=$1; print $0 " @ " FN ":" FNR }
/HIDEWORD ".*"/ { $1=$1; print $0 " @ " FN ":" FNR }
/COLON ".*"/ { $1=$1; print $0 " @ " FN ":" FNR }
/NONAME ".*"/ { $1=$1; print $0 " @ " FN ":" FNR }
/IMMED ".*"/ { $1=$1; print $0 " @ " FN ":" FNR }
/VARIABLE ".*"/ { $1=$1; print $0 " @ " FN ":" FNR }
/DVARIABLE ".*"/ { $1=$1; print $0 " @ " FN ":" FNR }
/NVARIABLE ".*"/ { $1=$1; print $0 " @ " FN ":" FNR }
/USER ".*"/ { $1=$1; print $0 " @ " FN ":" FNR }
/VALUE ".*"/ { $1=$1; print $0 " @ " FN ":" FNR }
/DEFER ".*"/ { $1=$1; print $0 " @ " FN ":" FNR }
/UDEFER ".*"/ { $1=$1; print $0 " @ " FN ":" FNR }
/CONSTANT ".*"/ { $1=$1; print $0 " @ " FN ":" FNR }
/CON ".*"/ { $1=$1; print $0 " @ " FN ":" FNR }
/DATA ".*"/ { $1=$1; print $0 " @ " FN ":" FNR }
/ENVINRONMENT ".*"/ { $1=$1; print $0 " @ " FN ":" FNR }
# RISC-V
/CSR ".*"/ { $1=$1; print $0 " @ " FN ":" FNR }
# ARM
/ARM_COLON ".*"/ { $1=$1; print $0 " @ " FN ":" FNR }
/ARM_CONSTANT ".*"/ { $1=$1; print $0 " @ " FN ":" FNR }
