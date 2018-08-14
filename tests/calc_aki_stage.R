# Test AKI staging
library(clinPK)
library(testit)

test0 <- calc_aki_stage(
  scr = c(3),
  t = c(0),
  egfr = 30,
  age = 15
)
test1 <- calc_aki_stage(
  scr = c(0.7, 0.8, 1.2, 1.6, 1),
  t = c(0, 24, 36, 48, 72)
)
test2 <- calc_aki_stage(
  scr = c(0.5, 0.7, 1.2, 1.6, 1.3),
  t = c(0, 24, 36, 48, 72),
  egfr = c(60, 40, 30, 36, 50),
  age = 17
)
assert(test0$aki == T & test0$stage == 3)
assert(test1$data$aki == c(F, F, T, T, T))
assert(test1$data$stage == c(0, 0, 1, 2, 1))
assert(test1$data$aki == c(F, F, T, T, T))
assert(test2$data$stage == c(0, 0, 3, 3, 2))

## more tests
test3 <- calc_aki_stage(
  scr = c(.6, .7, .9, 1.5),
  times = 1:4,
  method = "KDIGO"
)
test4 <- calc_aki_stage(
  scr = c(.6, .7, .9, .7),
  times = 1:4,
  method = "KDIGO"
)
test5 <- calc_aki_stage(
  scr = c(.6, .7, .9, 1.5),
  times = 1:4,
  method = "pRIFLE",
  sex = "male",
  age = 5,
  weight = 25,
  height = 120,
  egfr_method = "bedside_schwartz"
)
test6 <- calc_aki_stage(
  scr = c(.6, .7, .9, 1.3),
  baseline_egfr = 80,
  times = 1:4,
  method = "pRIFLE",
  sex = "male",
  age = 5,
  weight = 25,
  height = 120,
  egfr_method = "bedside_schwartz"
)
test7 <- calc_aki_stage(
  scr = c(1.3, .7, .9, 1.3),
  times = as.Date(c("8/1/2018", "8/3/2018", "8/5/2018", "8/12/2018"), "%m/%d/%Y"),
  method = "RIFLE",
  sex = "male",
  age = 5,
  weight = 25,
  height = 120,
  egfr_method = "cockcroft_gault"
)
assert(test3$stage == 2)
assert(test4$stage == 1)
assert(test5$stage == "F")
assert(test6$stage == "I")
assert(test7$stage == "none")
