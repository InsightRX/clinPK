test_that("egfr call works", {
  test1 <- calc_kgfr(
    scr1 = 1.39,
    scr2 = 1.19,
    weight = 64,
    height = 163,
    egfr_method = 'mdrd',
    age = 20,
    sex = 'male',
    time_delay = 26
  )
  expect_equal(round(test1, 2), 98.91)
})

test_that("unit conversion works", {
  test2 <- calc_kgfr(
    scr1 = 300,
    scr2 = 350,
    scr_unit = 'umol/l',
    vd = 38,
    egfr = 85,
    time_delay = 16
  )
  expect_equal(round(test2, 1), 112.9)
})

test_that("kGFR will not be negative", {
  test3 <- calc_kgfr(
    scr1 = 1,
    scr2 = 100,
    vd = 50,
    time_delay = 24,
    egfr = 60
  )
  expect_true(round(test3) >= 0)
})

test_that("directionality of change makes sense", {
  test4 <- calc_kgfr(
    scr1 = 1,
    scr2 = 2,
    scr_unit = 'mg/dl',
    weight = 64,
    height = 163,
    egfr_method = 'cockcroft_gault',
    age = 20,
    sex = 'male',
    time_delay = 12
  )
  test5 <- calc_kgfr(
    scr1 = 2,
    scr2 = 1,
    scr_unit = 'mg/dl',
    weight = 64,
    height = 163,
    egfr_method = 'cockcroft_gault',
    age = 20,
    sex = 'male',
    time_delay = 12
  )
  expect_true(test4 < test5)
})
