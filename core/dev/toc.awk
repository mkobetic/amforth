# Scavenge the list of files in build/amforth.dep and
# spit out the headers of all the words encountered.
# Along the way attach the file:line location to each.

function normalize(path) {
    path = (path ~ /^\//) ? path : ENVIRON["PWD"] "/" path
    do {
        old_path = path;
        # Use gsub to replace all occurrences in the current string
        # gsub modifies target_str in place and returns the number of substitutions
        gsub(/\/[^\/]+\/\.\.\//, "/", path);
    } while (path != old_path); # Continue looping as long as a substitution occurred
    sub(ENVIRON["AMFORTH"] "/", "", path)
    return path;
}

# match($0, /COLON[[:space:]]+".*",/) { print substr($0, RSTART + 7, RLENGTH - 9) }
FNR == 1 {
    if (FILENAME ~ /macros\.inc$/) nextfile;
    FN = normalize(FILENAME)
}
/CODEWORD[[:space:]]+".*"/ { $1=$1; print $0 " @ " FN ":" FNR }
/CODEALIAS[[:space:]]+".*"/ { $1=$1; print $0 " @ " FN ":" FNR }
/HEADLESS[[:space:]]+".*"/ { $1=$1; print $0 " @ " FN ":" FNR }
/HIDEWORD[[:space:]]+".*"/ { $1=$1; print $0 " @ " FN ":" FNR }
/COLON[[:space:]]+".*"/ { $1=$1; print $0 " @ " FN ":" FNR }
/NONAME[[:space:]]+".*"/ { $1=$1; print $0 " @ " FN ":" FNR }
/IMMED[[:space:]]+".*"/ { $1=$1; print $0 " @ " FN ":" FNR }
/VARIABLE[[:space:]]+".*"/ { $1=$1; print $0 " @ " FN ":" FNR }
/DVARIABLE[[:space:]]+".*"/ { $1=$1; print $0 " @ " FN ":" FNR }
/NVARIABLE[[:space:]]+".*"/ { $1=$1; print $0 " @ " FN ":" FNR }
/USER[[:space:]]+".*"/ { $1=$1; print $0 " @ " FN ":" FNR }
/VALUE[[:space:]]+".*"/ { $1=$1; print $0 " @ " FN ":" FNR }
/DEFER[[:space:]]+".*"/ { $1=$1; print $0 " @ " FN ":" FNR }
/UDEFER[[:space:]]+".*"/ { $1=$1; print $0 " @ " FN ":" FNR }
/CONSTANT[[:space:]]+".*"/ { $1=$1; print $0 " @ " FN ":" FNR }
/CON[[:space:]]+".*"/ { $1=$1; print $0 " @ " FN ":" FNR }
/DATA[[:space:]]+".*"/ { $1=$1; print $0 " @ " FN ":" FNR }
/ENVINRONMENT[[:space:]]+".*"/ { $1=$1; print $0 " @ " FN ":" FNR }
# RISC-V
/CSR[[:space:]]+".*"/ { $1=$1; print $0 " @ " FN ":" FNR }
# ARM
/ARM_COLON[[:space:]]+".*"/ { $1=$1; print $0 " @ " FN ":" FNR }
/ARM_CONSTANT[[:space:]]+".*"/ { $1=$1; print $0 " @ " FN ":" FNR }
