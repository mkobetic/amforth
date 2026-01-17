# SPDX-License-Identifier: GPL-3.0-only
# temp6
# 
CODEWORD "t6>" , FROMTEMP6 # ( -- n ) 
    savetos
    mv s3,t6 
    NEXT

CODEWORD ">t6" , TOTEMP6 # ( -- n ) 
    mv t6,s3
    loadtos     
    NEXT

CODEWORD "t0>" , FROMTEMP0 # ( -- n ) 
    savetos
    mv s3,t0 
    NEXT

CODEWORD ">t0" , TOTEMP0 # ( -- n ) 
    mv t0,s3
    loadtos     
    NEXT


# CODEWORD "qq/mod" # ( ud u -- rem ql qh )
#     # detail is never easy 

#     lw t2 , 4(s4) # lsw 
#     lw t1 , 0(s4) # msw 
#     mv t0 , s3    # divider 

#     sw zero , 4(s4)
#     sw zero , 0(s4)

#     divu s3, t1 , s3   # quotient msw 
#     rem  t1, t1 , t0   # t1 now has R

#     li t3 , 0x80000000 # 2^31

#     divu t4 , t3, t0   # q
#     remu t5 , t3, t0   # r

#     li t3 , 0x2        # 2
#     mulhu t6 , t3, t4  # 2x q from $80000000/u
#     mulhu t6 , t4, t1  # 2qR
    
#     divu t3, 
    
#     # oh this is going to be messy 
    

#     NEXT

CODEWORD "u+" # ( u2 u1 -- ud ) MATHS: add unsigned with carry to form unsigned double
       lw  t1 , 0(s4) # u2  
       mv  t0 , s3   # u1 

       add  t0 , t0 , t1 
       sltu s3 , t0 , t1
       sw   t0 , 0(s4)
       NEXT
       


         




    
