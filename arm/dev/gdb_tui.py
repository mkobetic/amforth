# Enhanced GDB windows for enhanced GDB forth layout.
# Loaded by tui-full.gdb
 
import gdb
from gdb_shared import *

# GdbCommandWindow can be used to define a TUI window
# that invokes a GDB command to produce its contents.
# See ForthParameterStack and ForthReturnStack for examples.
class GdbCommandWindow: 

    def __init__(self, tui_window): 
        self._tui_window = tui_window 
        tui_window.title = self.title
        gdb.events.before_prompt.connect(self.render)

    def get_contents(self):
        try:
            return gdb.execute(self.gdb_command, to_string=True)
        except Exception as exc: 
            return str(exc)

    def render(self): 
        if not self._tui_window.is_valid(): 
            return 
        self._tui_window.write(self.get_contents(), True)

# class ForthParameterStack(GdbCommandWindow):
#     title = "Parameter Stack"
#     gdb_command = ".s"

# class ForthReturnStack(GdbCommandWindow):
#     title = "Return Stack"
#     gdb_command = ".r"

def value(val):
    # If val is in the flash code range, treat it as address
    if is_code_address(val):
        return address(val)
    dec = val.format_string(format="d")
    hex = val.format_string(format="x")
    if 0 <= val and val <= 0xFFFF:
        # include binary format if val is sufficiently small
        bin = val.format_string(format="t")
        if val <= 0x100:
            char = val.format_string(format="c")
            return f"{char} {hex} {bin}"
        else:
            return f"{dec} {hex} {bin}"
    else: 
        return f"{dec} {hex}"

def address(val):
    return val.format_string(format="a")

# ForthRegisterWindow is a custom register view
# showing registers based on what they are used for in AmForth.
class ForthRegisterWindow: 

    def __init__(self, tui_window): 
        self._tui_window = tui_window 
        tui_window.title = "Forth Registers"
        gdb.events.before_prompt.connect(self.render)

    def prefix(self, name, fName = None):
        if fName:
            if len(fName) > 3:
                return f"{name}/{fName}:\t"
            else:
                return f"{name}/{fName}:\t\t"
        else:
            return f"{name}:\t\t"

    def value_register(self, frame, name, fName = None):
        try:
            reg = frame.read_register(name)
            return f"{self.prefix(name, fName)}{value(reg)}"
        except Exception:
            return f"{self.prefix(name, fName)}<unavailable>"

    def addres_register(self, frame, name, fName = None):
        try:
            reg = frame.read_register(name)
            addr = reg.format_string(format="a")
            return f"{self.prefix(name, fName)}{addr}"
        except Exception:
            return f"{self.prefix(name, fName)}<unavailable>"

    def status_register(self, frame, name):
        try:
            reg = frame.read_register(name)
            hex = reg.format_string(format="x")
            msb = reg.bytes[3]
            flags = 'N' if msb & 0x80 else '.'
            flags += 'Z' if msb & 0x40 else '.'
            flags += 'C' if msb & 0x20 else '.'
            flags += 'V' if msb & 0x10 else '.'
            flags += 'Q' if msb & 0x08 else '.'
            return f"{self.prefix(name)}{flags}... {hex}"
        except Exception:
            return f"{self.prefix(name)}<unavailable>"

    def find_psr_name(self, register_list):
        # Prioritize common names
        for name in ["xPSR", "xpsr", "cpsr"]:
            if name in register_list:
                return name
        # Generic fallback
        for name in register_list:
            if "psr" in name.lower():
                return name
        return None

    def get_contents(self):
        if not gdb.selected_thread():
            return "No thread selected."
        frame = gdb.selected_frame()
        if frame is None:
            return "no frame selected"
        architecture = gdb.selected_inferior().architecture()
        registers = [reg.name for reg in architecture.registers()]
        lines = [
            self.value_register(frame, "r0"),
            self.value_register(frame, "r1"),
            self.value_register(frame, "r2"),
            self.value_register(frame, "r3"),
            self.value_register(frame, "r4"),
            self.value_register(frame, "r5"),
            self.value_register(frame, "r6", "TOS"),
            self.addres_register(frame, "r7", "PSP"),
            self.addres_register(frame, "r8", "FORTHW"),
            self.addres_register(frame, "r9", "FORTHIP"),
            self.addres_register(frame, "r10", "UP"),
            self.value_register(frame, "r11", "RLINDEX"),
            self.value_register(frame, "r12", "RLLIMIT"),
            self.addres_register(frame, "sp", "RSP"),
            self.addres_register(frame, "lr"),
            self.addres_register(frame, "pc"),
        ]
        
        psr_name = self.find_psr_name(registers)
        if psr_name:
            lines.append(self.status_register(frame, psr_name))
        else:
            lines.append(self.prefix("PSR") + "<not found>")

        return "\n".join(lines)

    def render(self): 
        if not self._tui_window.is_valid(): 
            return
        try:
            contents = self.get_contents()
        except Exception as exc: 
            contents = str(exc)
        self._tui_window.write(contents, True)

# ForthParameterStack shows the contents of the PSP
class ForthParameterStack: 

    def __init__(self, tui_window): 
        self._tui_window = tui_window
        tui_window.title = "Forth Parameter Stack"
        gdb.events.before_prompt.connect(self.render)

    def get_contents(self):
        if not gdb.selected_thread():
            return "No thread selected."
        frame = gdb.selected_frame()
        if frame is None:
            return "no frame selected"
        tos = frame.read_register("r6")
        # TODO: need to detect when stack is empty
        lines = [ f"r6/TOS:\t\t{value(tos)}" ]
        psp = frame.read_register("r7")

        if not (RAM_lower_datastack <= int(psp) <= RAM_upper_datastack):
            return (f"PSP 0x{int(psp):x} out of range.\n"
                    f"Expected [0x{RAM_lower_datastack:x}, 0x{RAM_upper_datastack:x})")

        if psp == RAM_upper_datastack:
            return f"Empty"
    
        # cast psp from int to int* so that we can dereference it
        psp = psp.cast(psp.type.pointer())
        count = 0
        while psp < RAM_upper_datastack and count < 16:
            addr = psp.format_string(format="x")
            lines.append(f"{addr}:\t{value(psp.dereference())}")
            psp += 1
            count += 1
        return "\n".join(lines)

    def render(self): 
        if not self._tui_window.is_valid(): 
            return
        try:
            contents = self.get_contents()
        except Exception as exc: 
            contents = str(exc)
        self._tui_window.write(contents, True)

# ForthReturnStack shows the contents of the RSP
class ForthReturnStack: 

    def __init__(self, tui_window): 
        self._tui_window = tui_window
        tui_window.title = "Forth Return Stack"
        gdb.events.before_prompt.connect(self.render)

    def get_contents(self):
        if not gdb.selected_thread():
            return "No thread selected."
        frame = gdb.selected_frame()
        if frame is None:
            return "no frame selected"
        w = frame.read_register("r8") # FORTHW
        lines = [ f"r8/FORTHW:\t{address(w)}" ]
        ip = frame.read_register("r9") # FORTHIP
        lines.append(f"r9/FORTHIP:\t{address(ip)}")
        rsp = frame.read_register("sp")

        if not (RAM_lower_returnstack <= int(rsp) <= RAM_upper_returnstack):
            return (f"SP 0x{int(rsp):x} out of range.\n"
                    f"Expected [0x{RAM_lower_returnstack:x}, 0x{RAM_upper_returnstack:x})")

        # cast rsp from int to int* so that we can dereference it
        rsp = rsp.cast(rsp.type.pointer())
        count = 0
        while rsp < RAM_upper_returnstack and count < 16:
            addr = rsp.format_string(format="x")
            lines.append(f"{addr}:\t{gdb.format_address(int(rsp.dereference()))}")
            rsp += 1
            count += 1
        return "\n".join(lines)

    def render(self): 
        if not self._tui_window.is_valid(): 
            return
        try:
            contents = self.get_contents()
        except Exception as exc: 
            contents = str(exc)
        self._tui_window.write(contents, True)


gdb.register_window_type("fps", ForthParameterStack)
gdb.register_window_type("frs", ForthReturnStack)
gdb.register_window_type("fregs", ForthRegisterWindow)



# GDB Python API Notes
#
# To read memory: gdb.selected_inferior().read_memory(addr, length)
# returns memoryview which is a sort of bytearray see dir(memoryview)
# use gdb.format_address(address) to print address with symbol
#
#
# To read register: gdb.selected_frame().read_register("r6")
# returns gdb.Value
# to print value in hex use .format_string(format="x")
#
# gdb.lookup_type("unsigned int")
# gdb.selected_inferior().architecture()

# References
# https://undo.io/resources/enhance-gdb-with-tui/
