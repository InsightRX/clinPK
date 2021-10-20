test_that("AKI stage is calculated correctly", {
  # egfr < 35 and age < 18
  test0 <- calc_aki_stage(
    scr = c(3),
    t = c(0),
    egfr = 30,
    age = 15,
    verbose = FALSE
  )
  # increase by >= 0.3 mg/dl from t=36 to t=48
  test1 <- calc_aki_stage(
    scr = c(0.7, 0.8, 1.2, 1.6, 1),
    t = c(0, 24, 36, 48, 72),
    egfr = c(60, 40, 30, 36, 50),
    method = "KDIGO",
    verbose = FALSE
  )
  # increase by >= 0.3 mg/dl from t=24 to t=36
  test2 <- calc_aki_stage(
    scr = c(0.5, 0.7, 1.2, 1.6, 1.3),
    t = c(0, 24, 36, 48, 72),
    egfr = c(60, 40, 30, 36, 50),
    age = 17,
    verbose = FALSE
  )
  # increase by >= 0.3 mg/dl from t=24 to t=36
  test2a <- calc_aki_stage(
    scr = c(0.5, 0.7, 1.2, 1.6, 1.3),
    t = c(0, 24, 36, 48, 72),
    egfr = c(60, 40, 30, 36, 50),
    age = 21,
    verbose = FALSE
  )
  # increase by >= 0.3 mg/dl from t=24 to t=36
  test2b <- calc_aki_stage(
    scr = c(0.5, 0.7, 1.2, 1.6, 1.3),
    t = c(0, 24, 36, 48, 72),
    egfr = c(60, 40, 30, 36, 50),
    age = 21,
    return_obj = FALSE,
    force_numeric = TRUE,
    verbose = FALSE
  )
  # increase to 2x baseline
  test3 <- calc_aki_stage(
    scr = 1.9,
    t = 72,
    baseline_scr = 0.9,
    egfr = 40,
    age = 40,
    return_obj = FALSE,
    verbose = FALSE
  )
  # increase to 1.5x baseline, even though absolute increase is <0.3 mg/dl
  test4 <- calc_aki_stage(
    scr = 0.45,
    t = 72,
    baseline_scr = 0.3,
    egfr = 40,
    age = 40,
    return_obj = FALSE,
    verbose = FALSE
  )
  # increase to 3x baseline
  test5 <- calc_aki_stage(
    scr = 6,
    t = 48,
    baseline_scr = 2,
    egfr = 40,
    age = 40,
    return_obj = FALSE,
    verbose = FALSE
  )
  # increase by >=0.3 mg/dl BUT we don't know how fast
  test6 <- calc_aki_stage(
    scr = 1.5,
    t = 0,
    baseline_scr = 1.1,
    egfr = 40,
    age = 40,
    return_obj = FALSE,
    verbose = FALSE
  )

  expect_equal(test0$stage, "stage 3")
  expect_equal(test1$stage, "stage 1")
  expect_equal(test2$stage, "stage 3")
  expect_equal(test2$time_max_stage, 36)
  expect_equal(test2a$stage, "stage 1")
  expect_equal(test2a$time_max_stage, 36)
  expect_equal(test2b, 1)
  expect_equal(test3, "stage 2")
  expect_equal(test4, "stage 1")
  expect_equal(test5, "stage 3")
  expect_true(is.na(test6))
})


test_that("AKI stage is calculated correctly with other methods", {
  test3 <- calc_aki_stage(
    scr = c(.6, .7, .9, 1.5),
    times = 1:4,
    sex = "male",
    age = 50,
    weight = 80,
    height = 180,
    method = "KDIGO",
    force_numeric = TRUE,
    verbose = FALSE
  )
  test4 <- calc_aki_stage(
    scr = c(.6, .7, .8, .7),
    times = 1:4,
    sex = "male",
    age = 50,
    weight = 80,
    height = 180,
    method = "KDIGO",
    force_numeric = TRUE,
    verbose = FALSE
  )
  test5 <- calc_aki_stage(
    scr = c(.6, .7, .9, 1.5),
    times = 1:4,
    method = "pRIFLE",
    sex = "male",
    age = 5,
    weight = 25,
    height = 120,
    egfr_method = "bedside_schwartz",
    verbose = FALSE
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
    egfr_method = "bedside_schwartz",
    verbose = FALSE
  )
  test7 <- calc_aki_stage(
    scr = c(1, 1, 1, 1),
    times = as.Date(c("8/1/2018", "8/3/2018", "8/5/2018", "8/12/2018"), "%m/%d/%Y"),
    method = "RIFLE",
    sex = "male",
    age = 50,
    weight = 75,
    height = 180,
    egfr_method = "cockcroft_gault",
    verbose = FALSE
  )

  test8 <- calc_aki_stage(
    method = 'prifle',
    egfr = c(80, 59),
    verbose = FALSE
  )

  test9 <- calc_aki_stage(
    method = 'prifle',
    egfr = 60,
    baseline_egfr = 100,
    override_prifle_baseline = TRUE,
    verbose = FALSE
  )
  test10 <- calc_aki_stage(
    method = 'prifle',
    egfr = 60,
    baseline_egfr = 100,
    override_prifle_baseline = FALSE,
    verbose = FALSE
  )

  expect_equal(test3$stage, 1)
  expect_true(is.na(test4$stage))
  expect_equal(test5$stage, "F")
  expect_equal(test6$stage, "I")
  expect_true(is.na(test7$stage))
  expect_equal(test8$stage, "I")
  expect_equal(test9$data$baseline_egfr_reldiff, -0.4)
  expect_equal(test10$data$baseline_egfr_reldiff, -0.5)
})

test_that("Characters in scr are converted to numeric", {
  test_char_scr <- calc_aki_stage(
    method = "kDIGO",
    scr = c("<0.2", "1.5"),
    t = c(0, 24),
    egfr = c(50, 30),
    baseline_scr = 0.3,
    verbose = FALSE
  )
  expect_equal(test_char_scr$data$scr, c(0.2, 1.5))
})

test_that("calc_aki_stage errors if can't coerce scr to numeric", {
  expect_error(
    calc_aki_stage(
      method = "kDIGO",
      scr = c("a#$%#0.2", "1.5"),
      t = c(0, 24),
      egfr = c(50, 30),
      baseline_scr = 0.3,
      verbose = FALSE
    )
  )
})

test_that("calc_aki_stage correctly calculates baseline_scr", {
  test11 <- calc_aki_stage(
    method = "kDIGO",
    scr = c(0.5, 1.5),
    t = c(0, 24),
    egfr = c(50, 30),
    baseline_scr = "median",
    first_dose_time = 50,
    verbose = FALSE
  )
  expect_equal(test11$data$baseline_scr, c(1,1))
  test12 <- calc_aki_stage(
    method = "kDIGO",
    scr = c(0.5, 1.0, 1.5),
    t = c(0, 10, 24),
    egfr = c(50, 40, 30),
    baseline_scr = "median_before_treatment",
    first_dose_time = 12,
    verbose = FALSE
  )
  expect_equal(test12$data$baseline_scr, c(0.75, 0.75, 0.75))
  expect_equal(
    calc_aki_stage(
      method = "kDIGO",
      scr = c(0.5, 1.0, 1.5),
      t = c(0, 10, 24),
      egfr = c(50, 40, 30),
      baseline_scr = "lowest",
      first_dose_time = 12,
      verbose = FALSE
    )$data$baseline_scr, rep(0.5, 3))
  expect_error(
    calc_aki_stage(
      method = "kDIGO",
      scr = c(0.5, 1.0, 1.5),
      t = c(0, 10, 24),
      egfr = c(50, 40, 30),
      baseline_scr = "typo",
      first_dose_time = 12,
      verbose = FALSE
    )$data$baseline_scr)
})

test_that("Times are sorted", {
  akis <- calc_aki_stage(
    method = "kDIGO",
    scr = c(0.1, 3.2, 3.4),
    times = c(50, 12, 0),
    t = c(0, 24),
    first_dose_time = 23,
    egfr = c(50, 30),
    baseline_scr = "median_before_treatment",
    verbose = FALSE
  )
  expect_true(is.na(akis$stage))
})

test_that("age is not required if egfr is provided", {
  res <- calc_aki_stage(
    scr = 5,
    times = 0,
    egfr = 30,
    baseline_egfr = 30,
    method = "KDIGO",
    verbose = FALSE
  )
  # Stage 3 because scr >= 4
  expect_equal(res$stage, "stage 3")
})

test_that("kdigo_stage doesn't throw warning if no scr in last 48h", {
  dat <- data.frame(
    scr = c(1.5, 1.5, 1.9),
    t = c(-1, 0, 55),
    baseline_scr_diff = c(0, 0, 0.4),
    egfr = c(100, 100, 60)
  )

  expect_warning(kdigo_stage(dat, 1.5, 50), NA)
})
