test_that("AKI stage is calculated correctly", {
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
  test2b <- calc_aki_stage(
    scr = c(0.5, 0.7, 1.2, 1.6, 1.3),
    t = c(0, 24, 36, 48, 72),
    egfr = c(60, 40, 30, 36, 50),
    age = 21,
    return_obj = FALSE, force_numeric = TRUE
  )
  expect_true(test0$stage == "stage 3")
  expect_true(test1$stage == "stage 2")
  expect_true(test2$stage == "stage 3")
  expect_true(test2$time_max_stage == 36)
  expect_true(test2a$stage == "stage 1")
  expect_true(test2a$time_max_stage == 48)
  expect_true(test2b == 1)
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
    scr = c(1, 1, 1, 1),
    times = as.Date(c("8/1/2018", "8/3/2018", "8/5/2018", "8/12/2018"), "%m/%d/%Y"),
    method = "RIFLE",
    sex = "male",
    age = 50,
    weight = 75,
    height = 180,
    egfr_method = "cockcroft_gault"
  )

  test8 <- calc_aki_stage(
    method = 'prifle',
    egfr = c(80, 59)
  )

  test9 <- calc_aki_stage(method = 'prifle',
                          egfr = 60,
                          baseline_egfr = 100,
                          override_prifle_baseline = TRUE)
  test10 <- calc_aki_stage(method = 'prifle',
                           egfr = 60,
                           baseline_egfr = 100,
                           override_prifle_baseline = FALSE)

  expect_true(test3$stage == 2)
  expect_true(is.na(test4$stage))
  expect_true(test5$stage == "F")
  expect_true(test6$stage == "I")
  expect_true(is.na(test7$stage))
  expect_true(test8$stage == "I")
  expect_true(test9$data$baseline_egfr_reldiff == -0.4)
  expect_true(test10$data$baseline_egfr_reldiff == -0.5)
})

test_that("Characters in scr are converted to numeric", {
  test_char_scr <- calc_aki_stage(
    method = "kDIGO",
    scr = c("<0.2", "1.5"),
    t = c(0, 24),
    egfr = c(50, 30),
    baseline_scr = 0.3
  )
  expect_true(all.equal(test_char_scr$data$scr, c(0.2, 1.5)))
})

test_that("calc_aki_stage errors if can't coerce scr to numeric", {
  expect_error(
    calc_aki_stage(
      method = "kDIGO",
      scr = c("a#$%#0.2", "1.5"),
      t = c(0, 24),
      egfr = c(50, 30),
      baseline_scr = 0.3
    )
  )
})
