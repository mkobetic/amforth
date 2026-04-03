variable strlen
variable str
variable str-buf $20 allot

: source-string str @ strlen @ dup . ;
: refill-false ( -- false ) false ;

: (evaluate)
    break
    ['] source defer@ >r
    ['] refill defer@ >r
    >in @ >r
    0 >in !
    strlen !
    str !
    ['] source-string is source
    ['] interpret catch
    r> >in !
    r> is refill
    r> is source
    throw
;

\ : (evaluate) \ i*x addr len -- j*y
\     break
\     ['] source defer@ >r     \ 1. Save current source implementation
\     >in @ >r                 \ 2. Save current input offset
\     0 >in !                  \ 3. Reset offset to start of buffer
\     strlen !                 \ 4. Store string length
\     str !                    \ 5. Store string address
\     ['] source-string is source  \ 6. Redirect source to our buffer
\     ['] interpret catch      \ 7. Execute interpreter (with error trapping)
\     r> >in !                 \ 8. Restore original input offset
\     r> is source             \ 9. Restore original source
\     throw                    \ 10. Re-throw any caught errors
\ ;

: evaluate
   state @ if
     postpone (evaluate)
   else
     (evaluate)
   then
; immediate


: ww ( addr len -- )
    dup strlen !     \ a n
    str-buf swap move    \
    str-buf str ! 
    \ (evaluate)
;

: (evaluate-test)
    strlen !
    str !
    ['] source-string is source
    source
    ." len=" . 
    ." addr=" hex. 
    ['] source is source
;

\ s" 1 1 +" (evaluate-test)
