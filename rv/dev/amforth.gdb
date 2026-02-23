# AmForth specific gdb commands for ARM
# load with `source amforth.gdb`

# source shared core commands
source amforth-core.gdb

# command to dump the parameter stack
define .s
  # print TOS
  printf "TOS:     \t0x%x\n", $s3
  # grab the PSP
  set var $frame = (int*)$s4
  # rest of the parameter stack
  while $frame < &RAM_upper_datastack
    # print *(int)$frame
    x/x $frame
    set $frame = $frame + 1
  end
end

# command to dump the return stack
define .r
  # print W
  printf "FORTHW: \t0x%x\n", $s1
  # print IP
  printf "FORTHIP:\t0x%x\n", $s2
  set var $frame = (unsigned int*)$s5
  while $frame < &RAM_upper_returnstack
    # location of the next XT to run after EXIT
    x/a $frame
    # next XT to run after EXIT
    # x/a *(int)$frame
    set $frame = $frame + 1
  end
end