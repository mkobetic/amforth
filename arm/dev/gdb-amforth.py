# https://github.com/mkobetic/amforth/blob/unor4/appl/unor4/gdb-amforth.png
import gdb

# TODO: we should be able to read these from the symbol table
FlashStart = 0x00004000
FlashEnd = 0x00040000
RAM_lower_datastack = 0x20000000
RAM_upper_datastack = 0x20000080
RAM_lower_returnstack = 0x20000080
RAM_upper_returnstack = 0x20000100
RAM_lower_userarea = 0x20000100
RAM_upper_userarea = 0x20000188

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
        except gdb.error as exc: 
            return str(exc)

    def render(self): 
        if not self._tui_window.is_valid(): 
            return 
        self._tui_window.write(self.get_contents(), True)

# class ForthParameterStack(GdbCommandWindow):
#     title = "Parameter Stack"
#     gdb_command = ".s"

class ForthReturnStack(GdbCommandWindow):
    title = "Return Stack"
    gdb_command = ".r"

def value(val):
    # If val is in the flash code range, treat it as address
    if FlashStart <= val and val < FlashEnd:
        return val.format_string(format="a")
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
        reg = frame.read_register(name)
        return f"{self.prefix(name, fName)}{value(reg)}"

    def addres_register(self, frame, name, fName = None):
        reg = frame.read_register(name)
        addr = reg.format_string(format="a")
        return f"{self.prefix(name, fName)}{addr}"

    def status_register(self, frame, name):
        reg = frame.read_register(name)
        hex = reg.format_string(format="x")
        msb = reg.bytes[3]
        flags = 'N' if msb & 0x80 else '.'
        flags += 'Z' if msb & 0x40 else '.'
        flags += 'C' if msb & 0x20 else '.'
        flags += 'V' if msb & 0x10 else '.'
        flags += 'Q' if msb & 0x08 else '.'
        return f"{self.prefix(name)}{flags}... {hex}"

    def get_contents(self):
        frame = gdb.selected_frame()
        if frame is None:
            return "no frame selected"
        architecture = gdb.selected_inferior().architecture()
        registers = map(lambda reg: reg.name, architecture.registers())
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
            self.addres_register(frame, "sp"),
            self.addres_register(frame, "lr"),
            self.addres_register(frame, "pc"),
            # xPSR on Cortex-M3 is named xpsr
            self.status_register(frame, "xPSR" if ("xPSR" in registers) else "xpsr"),
        ]
        return "\n".join(lines)

    def render(self): 
        if not self._tui_window.is_valid(): 
            return
        try:
            contents = self.get_contents()
        except gdb.error as exc: 
            contents = str(exc)
        self._tui_window.write(contents, True)

# ForthParameterStack shows the contents of the PSP
class ForthParameterStack: 

    def __init__(self, tui_window): 
        self._tui_window = tui_window
        tui_window.title = "Forth Parameter Stack"
        gdb.events.before_prompt.connect(self.render)

    def get_contents(self):
        frame = gdb.selected_frame()
        if frame is None:
            return "no frame selected"
        tos = frame.read_register("r6")
        # TODO: need to detect when stack is empty
        lines = [ f"r6/TOS:\t\t{value(tos)}" ]
        psp = frame.read_register("r7")
        # cast psp from int to int* so that we can dereference it
        psp = psp.cast(psp.type.pointer())
        while psp < RAM_upper_datastack:
            addr = psp.format_string(format="x")
            lines.append(f"{addr}:\t{value(psp.dereference())}")
            psp += 1
        return "\n".join(lines)

    def render(self): 
        if not self._tui_window.is_valid(): 
            return
        try:
            contents = self.get_contents()
        except gdb.error as exc: 
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
