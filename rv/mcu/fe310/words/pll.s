#    "PRCI_BASE" : "$10008000",
#    "PRCI_HFROSCCFG":"$1000800",
#    "PRCI_HFXOSCCFG":"$1000804",
#    "PRCI_PLLCFG"   :"$1000808",
#    "PRCI_PLLDIV"   :"$100080C",
#    "PRCI_PROCMONCFG":"$10008F0"

CONSTANT "sysclock" SYSCLOCK 256
END SYSCLOCK

CODEWORD "pll", PLL
        
# PRCI_PLLCFG
# [02:00] PLL R input clock divider %01 is /2
# [03:03] RESERVED 
# [09:04] PLL F multiply ratio %11111 
# [11:10] PLL Q divider %11 is /8
# [15:12] RESERVED 
# [16:16] PLL select 
# [17:17] PLL Reference %1
# [18:18] PLL bypass

# (16/2)*64*(1/4)=64
#              9876 5432 1098 7654 3210            
# 000000000000 0111 0000 1101 1111 0001
#             R        F           Q         XTAL 
#.equ TMPPLL, (1) | (31 << 4) | (3 << 10) | (1 << 17) #  64MHz
.equ TMPPLL, (1) | (31 << 4) | (1 << 10) | (1 << 17) # 256MHz
#.equ TMPPLL, (1) | (31 << 4) | (2 << 10) | (1 << 17) # 128MHz

  li t3, TMPPLL
  la t4, PRCI_PLLCFG
  sw t3, 0(t4)

  li t0, 10000000 # approx 1s, for the hifive1-board
  li t0, 10000 # approx 0.001s, for the hifive1-board
1:
  addi t0,t0,-1
  bne t0,zero,1b

nope:
#  lw t5, 0(t4)
#  li t6, 1<<31
#  and t3,t5,t6
#  beq t3,zero,nope            

  lw t5, 0(t4)
  bgez t5,nope             

            
  lw t5, 0(t4)
           
#  li t6, 1 << 18
#  not a6,t6
#  and t3,t3,a6

  li t6, 1 << 16
  or t3, t5, t6

  sw t3, 0(t4)
NEXT
END PLL

