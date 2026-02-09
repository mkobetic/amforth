CODEWORD "cold", COLD /* ( i*x -- )(R: j*y -- ) assembler part of startup sequence, booting the VM */
/* This is assembly part of the startup sequence that creates the basic runtime environment for the virtual machine.
   It sets up the hardware, the stack pointers and the forth registers for the WARM word, 
   then boots the virtual machine by jumping to the inner interpreter.

   MCUs may override this to inject additional initialization at specific points.
*/

   ldr r0, =RAM_upper_returnstack
   mov sp, r0
   ldr psp, =RAM_upper_datastack

   ldr FORTHW, =XT_WARM
   b DO_EXECUTE

END COLD
