import gdb
import sys

# Append the GDB search directory to Python module search path
# so that the dev/ files can be imported as modules.
# `info directories` returns something like:
# Source directories searched: /Users/martin/forth/amforth/arm/mcu/lm4f120/../../dev:$cdir:$cwd
# Grab the first directory in the list and append it to sys.path.
# Note that this file still has to be sourced explicitly.
sys.path.append(gdb.execute("show directories", to_string=True).split(':')[1].strip())

def get_sym_val(name, default):
    try:
        return int(gdb.parse_and_eval(f"&{name}"))
    except gdb.error:
        return default

def is_code_address(addr):
    return (CodeFlashEnd == 0 or CodeFlashStart <= addr < CodeFlashEnd) or (CodeRamEnd == 0 or CodeRamStart <= addr < CodeRamEnd)

CodeFlashStart = get_sym_val("flash.low", 0)
CodeFlashEnd = get_sym_val("flash.max", 0)
CodeRamStart = get_sym_val("dp0.ram", 0)
CodeRamEnd = get_sym_val("dp.ram.max", 0)
RAM_lower_datastack = get_sym_val("RAM_lower_datastack", 0x20000000)
RAM_upper_datastack = get_sym_val("RAM_upper_datastack", 0x20000080)
RAM_lower_returnstack = get_sym_val("RAM_lower_returnstack", 0x20000080)
RAM_upper_returnstack = get_sym_val("RAM_upper_returnstack", 0x20000100)
RAM_lower_userarea = get_sym_val("RAM_lower_userarea", 0x20000100)
RAM_upper_userarea = get_sym_val("RAM_upper_userarea", 0x20000188)

