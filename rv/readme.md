# RISC-V 

RISC-V implementation of AmForth targets the RV32IMAC ISA. However, compressed instructions are excluded via assembler directives. 

# Register Usage

AmForth requires several registers for its operation. These registers are specifically mapped to RISC-V registers that are `callee-saved` based on RISC-V [calling convention][1]

AmForth Register             |  RISC-V Register
---------------------------- | ----------------
DEBUG: debugger support (*)  | s7
TOS: Top of Stack            | s3
DSP: Data Stack Pointer      | s4
FW: Word Pointer             | s1
FIP: Instruction Pointer     | s2
UP: User Pointer             | s6
RSP: Return Stack Pointer    | s5

(*) only used if WANT_DEBUGGER == YES

Registers t0 to t6 are used as scratch registers.

[1]: https://riscv.org/wp-content/uploads/2024/12/riscv-calling.pdf

