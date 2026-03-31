/*  ARMv7M System Memory Region 0xE0000000-0xFFFFFFFF
    Ref: ARMv7-M Architecture Reference Manual */

/* B3.2.2 System control and ID registers (System Control Space SCS) */
ARM_CONSTANT "CPUID", CPUID, 0xE000ED00 /* CPUID Base Register */
ARM_CONSTANT "ICSR", ICSR, 0xE000ED04 /* Interrupt Control Register */
ARM_CONSTANT "VTOR", VTOR, 0xE000ED08 /* Vector Table Offset Register */
ARM_CONSTANT "AIRCR", AIRCR , 0xE000ED0C /* Application Interrupt and Reset Control Register */
ARM_CONSTANT "SCR", SCR, 0xE000ED10 /* System Control Register */
ARM_CONSTANT "CCR", CCR, 0xE000ED14 /* Configuration and Control Register */
ARM_CONSTANT "SHPR1", SHPR1 , 0xE000ED18 /* System Handler Priority Register */
ARM_CONSTANT "SHPR2", SHPR2 , 0xE000ED1C /* System Handler Priority Register */
ARM_CONSTANT "SHPR3", SHPR3 , 0xE000ED20 /* System Handler Priority Register */
ARM_CONSTANT "SHCSR", SHCSR , 0xE000ED24 /* System Handler Control and State Register */
ARM_CONSTANT "CFSR", CFSR, 0xE000ED28 /* Configurable Fault Status Register */
ARM_CONSTANT "HFSR", HFSR, 0xE000ED2C /* HardFault Status Register */
ARM_CONSTANT "DFSR", DFSR, 0xE000ED30 /* Debug Fault Status Register */
ARM_CONSTANT "MMFAR", MMFAR, 0xE000ED34 /* MemManage Fault Address Register */
ARM_CONSTANT "BFAR", BFAR, 0xE000ED38 /* BusFault Address Register */
ARM_CONSTANT "AFSR", AFSR, 0xE000ED3C /* Auxiliary Fault Status Register */

ARM_CONSTANT "ICTR", ICTR , 0xE000E004 /* Interrupt Controller Type Register */
ARM_CONSTANT "ACTLR", ACTLR, 0xE000E008 /* Auxiliary Control Register */
ARM_CONSTANT "STIR", STIR, 0xE000EF00 /* Software Triggered Interrupt Register */


/* B3.4 Nested Vectored Interrupt Controller, NVIC
   ICTR.INTLINESNUM[5:0] (INTLINESNUM+1)*32 = number of implemented interrupts (max 496)  */
ARM_CONSTANT "NVIC_ISER", NVIC_ISER, 0xE000E100 /* Interrupt Set-Enable Registers (0-15), bit per interrupt */
ARM_CONSTANT "NVIC_ICER", NVIC_ICER, 0xE000E180 /* Interrupt Clear-Enable Registers (0-15), bit per interrupt */
ARM_CONSTANT "NVIC_ISPR", NVIC_ISPR, 0xE000E200 /* Interrupt Set-Pending Registers (0-15), bit per interrupt */
ARM_CONSTANT "NVIC_ICPR", NVIC_ICPR, 0xE000E280 /* Interrupt Clear-Pending Registers (0-15), bit per interrupt */
ARM_CONSTANT "NVIC_IABR", NVIC_IABR, 0xE000E300 /* Interrupt Active Bit Registers (0-15), bit per interrupt */
ARM_CONSTANT "NVIC_IPR", NVIC_IPR, 0xE000E400 /* Interrupt Priority Registers (0-123), byte per interrupt */

