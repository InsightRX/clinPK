library(clinPK)
library(testit)

A1 <- calc_amts_for_conc(10, parameters = list(CL = 10, V = 50), n_cmt = 1)
A2 <- calc_amts_for_conc(10, parameters = list(CL = 10, V = 50, V2 = 150), n_cmt = 2)
A3 <- calc_amts_for_conc(10, parameters = list(CL = 10, V = 50, V2 = 150, V3 = 80), n_cmt = 3)

assert("1comp", all(A1 == 500))
assert("2comp", all(A2 == c(500, 1500)))
assert("3comp", all(A3 == c(500, 1500, 800)))

