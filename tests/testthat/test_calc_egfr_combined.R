test_that("calculate egfr combined works: ckd_epi_as_2021", {
  egfr_female <- calc_egfr_combined(
    age = 50,
    sex = "female",
    scr = 1,
    cystatin = 1,
    verbose = FALSE
  )
  expect_equal(round(egfr_female$value, 1), 74.0)
  expect_equal(egfr_female$unit, "ml/min/1.73m^2")

  egfr_male <- calc_egfr_combined(
    age = 40,
    sex = "male",
    scr = 0.7,
    cystatin = 0.7,
    method = "ckd_epi_as_2021",
    verbose = FALSE
  )
  expect_equal(round(egfr_male$value, 1), 125.0)

  egfr_vector <- calc_egfr_combined(
    age = c(50, 40),
    sex = c("female", "male"),
    scr = c(1, 0.7),
    cystatin = c(1, 0.7),
    verbose = FALSE
  )
  expect_equal(round(egfr_vector$value, 1), c(74.0, 125.0))
})

test_that("calculate egfr combined works: ekfc", {
  egfr <- calc_egfr_combined(
    age = 60,
    sex = "female",
    scr = 0.9,
    cystatin = 1.2,
    method = "ekfc",
    verbose = FALSE
  )
  expect_equal(round(egfr$value, 1), 64.0)

  # mean of creatinine- and cystatin C-based EKFC equations
  egfr_cr <- calc_egfr(
    age = 60,
    sex = "female",
    scr = 0.9,
    method = "ekfc",
    verbose = FALSE
  )
  egfr_cys <- calc_egfr_cystatin(
    1.2,
    method = "ekfc",
    unit_out = "ml/min/1.73m2",
    age = 60
  )
  expect_equal(egfr$value, mean(c(egfr_cr$value, egfr_cys$value)))

  expect_warning(
    calc_egfr_combined(
      age = 10,
      sex = "male",
      scr = 0.5,
      cystatin = 0.8,
      method = "ekfc",
      scr_unit = "mg/dL"
    ),
    "validated in adults only"
  )
})

test_that("calculate egfr combined converts units", {
  egfr_mg_dl <- calc_egfr_combined(
    age = 50,
    sex = "female",
    scr = 1,
    cystatin = 1,
    verbose = FALSE
  )
  egfr_umol_l <- calc_egfr_combined(
    age = 50,
    sex = "female",
    scr = 88.4,
    scr_unit = "umol/L",
    cystatin = 1,
    verbose = FALSE
  )
  expect_equal(egfr_umol_l$value, egfr_mg_dl$value, tolerance = 1e-3)

  egfr_abs <- calc_egfr_combined(
    age = 50,
    sex = "female",
    scr = 1,
    cystatin = 1,
    bsa = 1.6,
    relative = FALSE,
    unit_out = "L/hr",
    verbose = FALSE
  )
  expect_equal(egfr_abs$value, egfr_mg_dl$value * 1.6 / 1.73 * 60 / 1000)
  expect_equal(egfr_abs$unit, "l/hr")

  # BSA calculated from weight and height
  egfr_bsa <- calc_egfr_combined(
    age = 50,
    sex = "female",
    scr = 1,
    cystatin = 1,
    weight = 70,
    height = 165,
    relative = FALSE,
    verbose = FALSE
  )
  expect_equal(egfr_bsa$bsa, calc_bsa(70, 165, "dubois")$value)

  egfr_capped <- calc_egfr_combined(
    age = 50,
    sex = "female",
    scr = 1,
    cystatin = 1,
    max_value = 60,
    verbose = FALSE
  )
  expect_equal(egfr_capped$value, 60)
  expect_equal(egfr_capped$capped$max_n, 1)
})

test_that("calculate egfr combined checks inputs", {
  expect_error(
    calc_egfr_combined(age = 50, sex = "female", scr = 1, verbose = FALSE),
    "Sorry, missing covariates: cystatin"
  )
  expect_error(
    calc_egfr_combined(age = 50, scr = 1, cystatin = 1, verbose = FALSE),
    "Sorry, missing covariates: sex"
  )
  expect_error(
    calc_egfr_combined(
      age = 50,
      sex = "female",
      scr = 1,
      cystatin = 1,
      relative = FALSE,
      verbose = FALSE
    ),
    "Sorry, missing covariates: height, weight"
  )
  expect_false(
    calc_egfr_combined(
      age = 50,
      sex = "female",
      scr = 1,
      fail = FALSE,
      verbose = FALSE
    )
  )
  expect_error(
    calc_egfr_combined(
      age = c(50, 40),
      sex = "female",
      scr = c(1, 0.7),
      cystatin = c(1, 0.7, 0.8),
      verbose = FALSE
    ),
    "Vector inputs must all be the same length"
  )
  expect_error(
    calc_egfr_combined(
      age = c(50, 40),
      sex = "female",
      scr = c(1, 0.7),
      cystatin = c(1, 0.7),
      weight = c(70, 80, 90),
      height = 165,
      relative = FALSE,
      verbose = FALSE
    ),
    "Vector inputs must all be the same length"
  )
  expect_error(
    calc_egfr_combined(
      age = 50,
      sex = "female",
      scr = 1,
      cystatin = 1,
      cystatin_unit = "nmol/L",
      verbose = FALSE
    ),
    "only `mg/L` is supported"
  )
  expect_error(
    calc_egfr_combined(
      method = "mdrd",
      age = 50,
      sex = "female",
      scr = 1,
      cystatin = 1,
      verbose = FALSE
    )
  )
})

test_that("calc_egfr_combined validates unit_out", {
  expect_error(
    calc_egfr_combined(
      age = 50,
      sex = "female",
      scr = 1,
      cystatin = 1,
      unit_out = "banana",
      verbose = FALSE
    ),
    "`unit_out` must be one of"
  )
})

test_that("calculate egfr combined warns for children with ckd_epi_as_2021", {
  expect_warning(
    calc_egfr_combined(
      method = "ckd_epi_as_2021",
      age = c(50, 10),
      sex = c("female", "male"),
      scr = c(1, 0.5),
      scr_unit = "mg/dL",
      cystatin = c(1, 0.8)
    ),
    "CKD-EPI creatinine-cystatin C equation was developed in adults only"
  )
  expect_no_warning(
    calc_egfr_combined(
      method = "ckd_epi_as_2021",
      age = 10,
      sex = "male",
      scr = 0.5,
      cystatin = 0.8,
      verbose = FALSE # No warnings
    )
  )
  expect_no_warning(
    calc_egfr_combined(
      method = "ckd_epi_as_2021",
      age = 50,
      sex = "female",
      scr = 1,
      scr_unit = "mg/dL",
      cystatin = 1
    )
  )
})
