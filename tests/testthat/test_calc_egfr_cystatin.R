test_that("calculate egfr based on cystatin works", {
  expect_equal(
    round(calc_egfr_cystatin(1.3, unit_out = "ml/min")$value, 1),
    54.1
  )
  expect_equal(
    round(calc_egfr_cystatin(1.3, unit_out = "l/hr")$value, 2), 3.24
  )
  expect_equal(
    round(calc_egfr_cystatin(1.3, unit_out = "ml/hr")$value, 1), 3244.1
  )
  expect_equal(
    round(
      calc_egfr_cystatin(1.3, unit_out = "ml/min", method = "larsson")$value,
      1
    ), 55.5
  )
  expect_equal(
    round(
      calc_egfr_cystatin(1.3, unit_out = "mL/min/1.73m2", method = "Hoek")$value,
      1
    ), 57.5
  )
  expect_error(
    calc_egfr_cystatin(1.3, unit_out = "ml/min", method = "hoek")
  )
})

test_that("calculate egfr based on cystatin works: ekfc", {
  # cystatin C at the healthy median (Q) gives eGFR of 107.3 until age 40
  egfr_at_q <- calc_egfr_cystatin(
    0.83,
    method = "ekfc",
    unit_out = "ml/min/1.73m2",
    age = 30
  )
  expect_equal(egfr_at_q$value, 107.3)

  egfr_age_60 <- calc_egfr_cystatin(
    1.2,
    method = "ekfc",
    unit_out = "ml/min/1.73m2",
    age = 60
  )
  expect_equal(round(egfr_age_60$value, 1), 61.8)

  egfr_vector <- calc_egfr_cystatin(
    c(0.83, 1.2),
    method = "ekfc",
    unit_out = "ml/min/1.73m2",
    age = c(30, 60)
  )
  expect_equal(round(egfr_vector$value, 1), c(107.3, 61.8))

  expect_error(
    calc_egfr_cystatin(1.2, method = "ekfc", age = 60),
    "needs to be mL/min/1.73m2"
  )
  expect_error(
    calc_egfr_cystatin(1.2, method = "ekfc", unit_out = "ml/min/1.73m2"),
    "Sorry, missing covariates: age"
  )
  expect_warning(
    calc_egfr_cystatin(
      1.2,
      method = "ekfc",
      unit_out = "ml/min/1.73m2",
      age = 10
    ),
    "validated in adults only"
  )
})

test_that("calculate egfr based on cystatin works: ckd_epi", {
  egfr_female <- calc_egfr_cystatin(
    1.4,
    method = "ckd_epi",
    unit_out = "ml/min/1.73m2",
    age = 65,
    sex = "female"
  )
  expect_equal(round(egfr_female$value, 1), 45.4)

  egfr_male <- calc_egfr_cystatin(
    0.7,
    method = "ckd_epi",
    unit_out = "ml/min/1.73m2",
    age = 40,
    sex = "male"
  )
  expect_equal(
    round(egfr_male$value, 1),
    round(133 * (0.7 / 0.8)^-0.499 * 0.996^40, 1)
  )

  expect_error(
    calc_egfr_cystatin(
      1.4,
      method = "ckd_epi",
      unit_out = "ml/min/1.73m2",
      age = 65
    ),
    "Sorry, missing covariates: sex"
  )
  expect_error(
    calc_egfr_cystatin(1.4, method = "ckd_epi", age = 65, sex = "female"),
    "needs to be mL/min/1.73m2"
  )
})

test_that("calculate egfr based on cystatin checks cystatin unit", {
  expect_equal(
    calc_egfr_cystatin(1.3, cystatin_unit = "mg/l")$value,
    calc_egfr_cystatin(1.3)$value
  )
  expect_error(
    calc_egfr_cystatin(1.3, cystatin_unit = "nmol/L"),
    "only `mg/L` is supported"
  )
})

test_that("convert_egfr_cystatin validates cystatin unit", {
  expect_equal(convert_egfr_cystatin(c(1, 1.3), "mg/L"), c(1, 1.3))
  expect_equal(
    convert_egfr_cystatin(c(1, 1.3), c("mg/L", "mg/l")),
    c(1, 1.3)
  )
  expect_message(
    expect_equal(convert_egfr_cystatin(1, NULL), 1),
    "assuming mg/L"
  )
  expect_error(
    convert_egfr_cystatin(c(1, 1.3), c("mg/L", "nmol/L")),
    "only `mg/L` is supported"
  )
})

test_that("calculate egfr based on cystatin checks input lengths", {
  expect_error(
    calc_egfr_cystatin(c(1, 1.3), age = c(50, 60, 70)),
    "Vector inputs must all be the same length"
  )
  expect_error(
    calc_egfr_cystatin(
      c(1, 1.3),
      method = "ekfc",
      unit_out = "ml/min/1.73m2",
      age = 50,
      sex = c("male", "female", "male")
    ),
    "Vector inputs must all be the same length"
  )
  # sex is only validated when the method uses it
  egfr_grubb <- calc_egfr_cystatin(1.3, sex = "unknown")
  expect_equal(egfr_grubb$value, calc_egfr_cystatin(1.3)$value)
})
