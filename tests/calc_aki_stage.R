# Test AKI staging
library(clinPK)
library(testit)

test0 <- calc_aki_stage(
  scr = c(3),
  t = c(0),
  egfr = 30,
  age = 15,
  verbose = F
)
test1 <- calc_aki_stage(
  scr = c(0.7, 0.8, 1.2, 1.6, 1),
  t = c(0, 24, 36, 48, 72),
  egfr = c(60, 40, 30, 36, 50),
  method = "KDIGO"
)
test2 <- calc_aki_stage(
  scr = c(0.5, 0.7, 1.2, 1.6, 1.3),
  t = c(0, 24, 36, 48, 72),
  egfr = c(60, 40, 30, 36, 50),
  age = 17
)
test2a <- calc_aki_stage(
  scr = c(0.5, 0.7, 1.2, 1.6, 1.3),
  t = c(0, 24, 36, 48, 72),
  egfr = c(60, 40, 30, 36, 50),
  age = 21
)
assert(test0$stage == "stage 3")
assert(test1$stage == "stage 2")
assert(test2$stage == "stage 3")
assert(test2a$stage == "stage 1")

test3 <- calc_aki_stage(
  scr = c(.6, .7, .9, 1.5),
  times = 1:4,
  sex = "male",
  age = 50,
  weight = 80,
  height = 180,
  method = "KDIGO",
  force_numeric = TRUE
)
test4 <- calc_aki_stage(
  scr = c(.6, .7, .9, .7),
  times = 1:4,
  sex = "male",
  age = 50,
  weight = 80,
  height = 180,
  method = "KDIGO",
  force_numeric = TRUE
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
assert(is.na(test4$stage))
assert(test5$stage == "F")
assert(test6$stage == "I")
assert(is.na(test7$stage))

