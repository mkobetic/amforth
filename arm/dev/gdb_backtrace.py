import gdb
from gdb_shared import *
from gdb.unwinder import Unwinder, FrameId

class ForthUnwinder(Unwinder):
    """Unwinder for Forth return stack.
    
    GDB uses the unwinder to interpret the return stack. It seeds the process with a first pending_frame
    that includes the state of all registers, the PC is set to whatever the current PC value is.
    SP points at the top of the return stack.
    The unwinder then builds and return unwind_info for the next pending frame (in the __call__ method).
    The __call__ method is called repeatedly until a None is returned which ends the backtracce building process.
    """
    
    def __init__(self):
        super().__init__("ForthUnwinder")
        self.first_frame_done = False
    
    def __call__(self, pending_frame):
        try:
            sp = pending_frame.read_register("sp")
            
            while True:
                # Stop if we hit bottom of the stack
                if not (RAM_lower_returnstack <= int(sp) < RAM_upper_returnstack):
                    self.first_frame_done = False
                    return None

                if self.first_frame_done:
                    sp_ptr = sp.cast(gdb.lookup_type("unsigned int").pointer())
                    ret_addr = sp_ptr.dereference()
                else:
                    # Adjust SP for first frame (FORTHIP effectively extends RSP by one slot)
                    sp = gdb.Value(int(sp) - 4).cast(sp.type)
                    ret_addr = pending_frame.read_register("r9")
                    self.first_frame_done = True

                # If ret_addr doesn't look like a valid code address, skip that stack entry
                # because it's likely a value stashed in the return stack.
                if is_code_address(ret_addr):
                    break
                print(f"skipping non code: #{pending_frame.location()}: {ret_addr}")
                sp = gdb.Value(int(sp) + 4).cast(sp.type)

            # Create frame ID for next frame: use SP (as identity) and ret_addr (as code address)
            frame_id = FrameId(sp, ret_addr)
            unwind_info = pending_frame.create_unwind_info(frame_id)
            
            # Next frame's SP is current SP + 4 (pop one return address)
            sp = gdb.Value(int(sp) + 4).cast(sp.type)
            # Next frame's PC is the return address we just popped - 4
            # because we're executing the XT before the return address.
            pc = gdb.Value(int(ret_addr) - 4).cast(ret_addr.type)
            unwind_info.add_saved_register("pc", pc)
            unwind_info.add_saved_register("sp", sp)            
            return unwind_info

        except Exception as e: 
            import traceback
            traceback.print_exc()
            self.first_frame_done = False
            return None

# Register the unwinder
gdb.unwinder.register_unwinder(None, ForthUnwinder(), replace=False)

# Keeping the code below in case we do need FrameDecorators later.
# This shows how to put it together.

# Frame decorator to enhance Forth frame information
# class ForthFrameDecorator(gdb.FrameDecorator.FrameDecorator):
#     """Decorator to enhance Forth frame display with symbol information."""
    
#     def __init__(self, frame):
#         super().__init__(frame)
    
#     def function(self):
#         """Get function name from symbol."""
#         try:
#             frame = self.inferior_frame()
#             if frame is None:
#                 return None
#             pc = frame.pc()
#             # Look up the symbol at this address
#             try:
#                 block = gdb.block_for_pc(pc)
#                 if block and block.function:
#                     return block.function.name
#             except:
#                 pass
#             # Try to get just the symbol name
#             try:
#                 result = gdb.execute(f"info symbol 0x{pc:x}", to_string=True).strip()
#                 if result and "not in any" not in result:
#                     # Extract just the symbol name (before any +offset)
#                     parts = result.split()
#                     if parts:
#                         return parts[0]
#             except:
#                 pass
#         except:
#             pass
#         return None
    
#     def filename(self):
#         """Get source filename if available."""
#         try:
#             frame = self.inferior_frame()
#             if frame is None:
#                 return None
#             pc = frame.pc()
#             sal = gdb.find_pc_line(pc)
#             # Only return if we have valid debug info
#             if sal and sal.symtab and sal.line > 0:
#                 return sal.symtab.filename
#         except:
#             pass
#         return None
    
#     def line(self):
#         """Get source line number if available."""
#         try:
#             frame = self.inferior_frame()
#             if frame is None:
#                 return None
#             pc = frame.pc()
#             sal = gdb.find_pc_line(pc)
#             # Only return if we have valid debug info
#             if sal and sal.line > 0:
#                 return sal.line
#         except:
#             pass
#         return None

# class ForthFrameFilter:
#     """Filter to apply ForthFrameDecorator to all frames."""
    
#     def __init__(self):
#         self.name = "ForthFrameFilter"
#         self.priority = 100
#         self.enabled = True
#         gdb.frame_filters[self.name] = self
    
#     def filter(self, frame_iter):
#         # Wrap each frame with our decorator
#         for frame in frame_iter:
#             yield ForthFrameDecorator(frame)

# ForthFrameFilter()
