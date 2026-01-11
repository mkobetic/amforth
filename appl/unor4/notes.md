# linker files

All main address pointers should come from the memmap:
* Good introduction: https://mcyoung.xyz/2021/06/01/linker-script/
* Tock OS has an interesting structure of general and board specific linker files that might be worth following:
    https://github.com/tock/tock/blob/master/boards/build_scripts/tock_kernel_layout.ld

# variable fix

* split DP and HERE (VP)
* what's the purpose of REVEAL and NEWEST ?
* why is NEWEST DVARIABLE
* what is the stack sig for: HEADER, DOTO1  

# status

Assembler errors from trying to define the symbol in linker scripts and
dropping the definitions from assembler files and
.set rampointer, vp0  

martin@mbp unor4 % make build/amforth.o
cat words/build-info.tmpl | sed "s/%d/ `date`/" | sed "s/%r/## unor4...origin-unor4/" > words/build-info.s
arm-none-eabi-as -g --warn --fatal-warnings -achlms=build/amforth.lst-as -I../../arm -I ../../arm/devices/cortex-m4 -I ../../shared -o build/amforth.o amforth.s
amforth.s: Assembler messages:
amforth.s: Error: symbol definition loop encountered at `rampointer'
amforth.s: Error: invalid operands (*GAS `expr' section* and *UND* sections) for `+' when setting `rampointer'
amforth.s: Error: Invalid operation on symbol
amforth.s: Error: can't resolve value for symbol `rampointer'
amforth.s: Error: invalid operands (*ABS* and *UND* sections) for `*' when setting `USER_FOLLOWER'
amforth.s: Error: invalid operands (*ABS* and *UND* sections) for `*' when setting `USER_RP'
amforth.s: Error: invalid operands (*ABS* and *UND* sections) for `*' when setting `USER_SP0'
amforth.s: Error: invalid operands (*ABS* and *UND* sections) for `*' when setting `USER_SP'
amforth.s: Error: invalid operands (*ABS* and *UND* sections) for `*' when setting `USER_HANDLER'
amforth.s: Error: invalid operands (*ABS* and *UND* sections) for `*' when setting `USER_BASE'
amforth.s: Error: invalid operands (*ABS* and *UND* sections) for `*' when setting `USER_UDT'
amforth.s: Error: invalid operands (*ABS* and *UND* sections) for `*' when setting `USER_RP'
amforth.s: Error: invalid operands (*ABS* and *UND* sections) for `*' when setting `USER_SP'
amforth.s: Error: invalid operands (*ABS* and *UND* sections) for `*' when setting `USER_SP0'
amforth.s: Error: invalid operands (*ABS* and *UND* sections) for `*' when setting `USER_BASE'
amforth.s: Error: symbol definition loop encountered at `rampointer'
amforth.s: Error: invalid operands (*GAS `expr' section* and *UND* sections) for `+' when setting `rampointer'
amforth.s: Error: Invalid operation on symbol
amforth.s: Error: can't resolve value for symbol `rampointer'
amforth.s: Error: symbol definition loop encountered at `rampointer'
amforth.s: Error: invalid operands (*GAS `expr' section* and *UND* sections) for `+' when setting `rampointer'
amforth.s: Error: Invalid operation on symbol
amforth.s: Error: can't resolve value for symbol `rampointer'
amforth.s: Error: symbol definition loop encountered at `rampointer'
amforth.s: Error: invalid operands (*GAS `expr' section* and *UND* sections) for `+' when setting `rampointer'
amforth.s: Error: Invalid operation on symbol
amforth.s: Error: can't resolve value for symbol `rampointer'
amforth.s: Error: invalid operands (*ABS* and *UND* sections) for `*' when setting `USER_HANDLER'
amforth.s: Error: symbol definition loop encountered at `rampointer'
amforth.s: Error: invalid operands (*GAS `expr' section* and *UND* sections) for `+' when setting `rampointer'
amforth.s: Error: Invalid operation on symbol
amforth.s: Error: can't resolve value for symbol `rampointer'
amforth.s: Error: symbol definition loop encountered at `rampointer'
amforth.s: Error: invalid operands (*GAS `expr' section* and *UND* sections) for `+' when setting `rampointer'
amforth.s: Error: Invalid operation on symbol
amforth.s: Error: can't resolve value for symbol `rampointer'
amforth.s: Error: symbol definition loop encountered at `rampointer'
amforth.s: Error: invalid operands (*GAS `expr' section* and *UND* sections) for `+' when setting `rampointer'
amforth.s: Error: Invalid operation on symbol
amforth.s: Error: can't resolve value for symbol `rampointer'
words/at-usart.s:140: Error: undefined symbol refill_buf_size used as an immediate value
make: *** [build/amforth.o] Error 1
