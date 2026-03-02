\ display memory stats of the running system
\ shows USED / TOTAL (in bytes) and % used for each memory area

: stats.flash
    ." FLASH:    "
    memmode if dp else dp.flash then
    flash.low - dup 7 u.r space #47 emit
    #100 *
    flash.max flash.low - dup 7 u.r space #66 emit
    / 4 u.r #37 emit cr
;

\ Shows stats for the active PVFLASH arena
: stats.pvflash 
    ." PVFLASH:  "
    pvp pvarena - dup 7 u.r space #47 emit
    #100 *
    pvarena.size dup 7 u.r space #66 emit
    / 4 u.r #37 emit cr
;

: stats.rampool 
    ." RAM pool: "
    vp vp0 - dup 7 u.r space #47 emit
    #100 *
    vp.max vp0 - dup 7 u.r space #66 emit
    / 4 u.r #37 emit cr
;

: stats.ramdict 
    ." RAM dict: "
    memmode if dp.ram else dp then 
    dp0.ram - dup 7 u.r space #47 emit
    #100 *
    dp.ram.max dp0.ram - dup 7 u.r space #66 emit
    / 4 u.r #37 emit cr
;

: stats stats.flash stats.pvflash stats.rampool stats.ramdict ;
