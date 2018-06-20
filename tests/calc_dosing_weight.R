library(clinPK)
library(testit)

assert(round(calc_dosing_weight(weight = 160, height = 160, age= 50, sex = "female")$value,1) == 95.4)
assert(round(calc_dosing_weight(weight = 60, height = 160, age= 50, sex = "female")$value,1) == 52.4)
assert(round(calc_dosing_weight(weight = 50, height = 160, age= 50, sex = "female")$value,1) == 50)
