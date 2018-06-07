# Test AKI staging
library(clinPK)
library(testit)

test1 <- calc_aki_stage(
  scr = c(0.7, 0.8, 1.2, 1.6, 1),
  t = c(0, 24, 36, 48, 72)
)
test2 <- calc_aki_stage(
  scr = c(0.5, 0.7, 1.2, 1.6, 1.3),
  t = c(0, 24, 36, 48, 72),
  egfr = c(60, 30, 30, 36, 50),
  age = 17
)
assert(test1$aki == c(F, F, T, T, T))
assert(test1$stage == c(0, 0, 1, 2, 1))
assert(test1$aki == c(F, F, T, T, T))
assert(test2$stage == c(0, 0, 3, 3, 2))
