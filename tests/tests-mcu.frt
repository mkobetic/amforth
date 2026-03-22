\ tests/tests-mcu.frt

\ This is the driver file for running tests on development
\ boards. This file is passed through CPP which writes the
\ actual test file to the build directory of the mcu being
\ tested.

\ WARNING: some of the tests can run destructive operations,
\ so don't run against real MCUs without reviewing the tests.
    
\ CPP directive include will accept quoted arguements
\ but not unquoted ones. amforth-shell will accept both. 
\ Remember to quote the included files in this file and
\ any files that are included by files in this file...

>flash

\ amforth-shell requires a modified tester 
#include "tests/tester-mcu.frt"

\ output hardware and build information

hardware

\ The files that contain the tests. To comment out a
\ test file so that amforth-shell won't see it remember
\ to remove the # as well. 

#include "tests/cpp-core.fr"
#include "tests/core2.fr"
\ include "tests/pvalue.fr"

\ 

\ T{ 1 0  = -> TRUE }T

\ Below is used by the results processing awk
\ script so do not remove.     
s" TESTS FINISHED" type cr
\ Do not uncomment the #exit or CPP will complain
\ amforth-shell (with defaults) will still see it 
\ #exit

