# This file contains steps that are executed early in the assembly structure,
# before words definitions are compiled.
# Code here should pertain to general AmForth32 architecture only.

# Allocate core system RAM areas: stacks, tib, user areas, ...
# TODO: should this be configurable?
RAMALLOT ram_vector, 256*cellsize, 4
RAMALLOT datastack, datastack_size, 4
RAMALLOT returnstack, returnstack_size, 4
RAMALLOT leavestack, leavestack_size, 4
RAMALLOT userarea, userarea_size
RAMALLOT refill_buf, refill_buf_size, 4
