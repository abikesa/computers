// conducting a survival analysis using diagnosis as outcome
// length of stay as time to event
// censor death

cls
clear

global root : di "`c(pwd)'"

use "NIS_2014_Core_s.dta", clear

// drop missing DIED for death status
drop if missing(DIED) | DIED == 1

// generate discharge variable
capture drop discharge
gen discharge = 1 if DIED == 0
replace discharge = 0 if DIED == 1

// stset
stset LOS, failure(discharge)

// stcox
capture drop s0
stcox AGE i.RACE i.FEMALE i.ZIPINC_QRTL, basesurv(s0)

matrix beta = e(b)'
matrix var = e(V)'

// save results
preserve
drop if missing(s0)
keep _t _d s0
export delimited "s0.csv", replace
restore

putexcel set beta, replace
putexcel A1 = matrix(beta), names

putexcel set vari, replace
putexcel A1 = matrix(var), names
