# AmForth specific gdb commands
# load with `source amforth.gdb`

# command to dump the return stack
define .r
  set var $frame = $sp
  while $frame < &RAM_upper_returnstack
    # location of the next XT to run after EXIT
    x/a $frame
    # next XT to run after EXIT
    # x/a *(int)$frame
    set $frame = $frame + 4
  end
end

# command to dump the parameter stack
define .s
  # print TOS
  printf "TOS: %x\n", $r6
  # grab the PSP
  set var $frame = $r7
  # rest of the parameter stack
  while $frame < &RAM_upper_datastack
    # print *(int)$frame
    x/x $frame
    set $frame = $frame + 4
  end
end

# commands to dump a word header
# $arg0 should be the address of the corresponding header field

define .lfa
  set var $addr = $arg0
  printf "LFA 0x%08x: ", $addr
  output/a *(int)$addr
  printf "\n"
  set $addr = $addr + 4
  .ffa $addr
end

define .ffa
  set var $addr = $arg0
  set var $flags = *(unsigned int *)$addr
  printf "FFA 0x%08x: 0x%08x ", $addr, $flags
  # Decode flags
  if $flags & 0x0010
    printf "Imm, "
  end
  if $flags & 0x0020
    printf "Val, "
  end
  if $flags & 0x0040
    printf "Dfr, "
  end
  if $flags & 0x0080
    printf "Ini, "
  end
  if $flags & 0x0100
    # Flag_ramallot
    if $flags & 0x0001
      printf "RAVar, "
    end
    if $flags & 0x0002
      printf "RA2Var, "
    end
  end
  printf "\n"
  set $addr = $addr + 4
  .nfa $addr
end

define .nfa
  set var $addr = $arg0
  set var $len = *(char *)$addr
  set $addr = $addr + 1
  printf "NFA 0x%08x: \"%s\"\n", $addr, *(char *)$addr@$len
  set $addr = $addr + $len
  # need to 4-byte align the next field address
  set $addr = (((unsigned int)$addr + 3) & ~3)
  .cfa $addr
end

define .cfa
  set var $addr = $arg0
  printf "CFA 0x%08x: ", $addr
  output/a *(int)$addr
  printf "\n"
  set $addr = $addr + 4
  .pfa $addr
end

define .pfa
  set var $addr = $arg0
  set var $cfa = $addr - 4
  printf "PFA 0x%08x: ", $addr
  if *(int *)$cfa == $addr
    # CODEWORD
    list *$addr
  else
    output/a *(int)$addr
    printf "\n"
    set var $count = 5
    while $count > 0
      set $addr = $addr + 4
      printf "    0x%08x: ", $addr
      output/a *(int)$addr
      printf "\n"
      set $count = $count - 1
    end
  end
end

# dump important memory pointers
define .mps
  printf "DP: "
  x/a *(unsigned int *)PFA_DP
  x/a *(unsigned int *)(PFA_DP+4)
  printf "VP: "
  x/a *(unsigned int *)PFA_VP
  x/a *(unsigned int *)(PFA_VP+4)
end

# to help stepping through colon words, put a breakpoint at DO_EXECUTE
# and add commands to step twice to get into the next word's code.
# You can then move to the next word with 'continue'.
# Use 'disable/enable' to (de)activate the breakpoint.
define bde
  hbreak DO_EXECUTE
  commands
    step 2
  end
end
