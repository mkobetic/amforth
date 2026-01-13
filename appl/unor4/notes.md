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