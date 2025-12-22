# This should get autoloaded by GDB when started with `make gdb`
# Otherwise can also be loaded with source ./.gdbinit

# command dump the return stack
define .r
  set var $frame = $sp
  while $frame < 0x20000100
    # location of the next XT to run after EXIT
    x/a $frame
    # next XT to run after EXIT
    x/a *(int)$frame
    set $frame = $frame + 4
  end
end

# command to dump the parameter stack
define .s
  # print TOS
  print $r6
  # grab the PSP
  set var $frame = $r7
  # rest of the parameter stack
  while $frame < 0x20000080
    print *(int)$frame
    set $frame = $frame + 4
  end
end

# TUI for debugging
# ref: https://undo.io/resources/enhance-gdb-with-tui/
#
# create a new tui layout for forth
# tui new-layout forth regs 15 {-horizontal src 1 asm 1} 20 status 0 cmd 20
tui new-layout forth {-horizontal { {-horizontal src 2 asm 3 } 1 status 0 cmd 1 } 3 regs 1 } 1
# start the forth layout
layout forth
