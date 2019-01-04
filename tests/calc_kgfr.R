# Test kinetic GFR estimates
library(clinPK)
library(testit)

# Test egfr call works
test1 <- calc_kgfr(scr1 = 1.39,
                   scr2 = 1.19, 
                   weight = 64,
                   height = 163,
                   egfr_method = 'mdrd',
                   age = 20,
                   sex = 'male',
                   time_delay = 26)

# Test unit conversion works
test2 <- calc_kgfr(scr1 = 300, 
                   scr2 = 350,
                   scr_unit = 'umol/l',
                   vd = 38, 
                   egfr = 85, 
                   time_delay = 16)

# Test kGFR will not be negative
test3 <- calc_kgfr(scr1 = 1, 
                   scr2 = 100, 
                   vd = 50, 
                   time_delay = 24, 
                   egfr = 60)

#Test directionality of change makes sense
test4 <- calc_kgfr(scr1 = 1, scr2 = 2, scr_unit = 'mg/dl',
                   weight = 64, height = 163, 
                   egfr_method = 'cockcroft_gault',
                   age = 20, sex = 'male',
                   time_delay = 12)
test5 <- calc_kgfr(scr1 = 2, scr2 = 1, scr_unit = 'mg/dl',
                   weight = 64, height = 163, 
                   egfr_method = 'cockcroft_gault',
                   age = 20, sex = 'male',
                   time_delay = 12)


assert(round(test1, 2) == 104.81)
assert(round(test2, 1) == 112.9)
assert(round(test3) >= 0)
assert(test4 < test5)
