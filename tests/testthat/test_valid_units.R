test_that("valid_units returns valid units", {
  expect_equal(valid_units("age"), c("yrs", "weeks", "days", "years"))
  expect_equal(valid_units("height"), c("cm", "inch", "inches", "in"))
})

test_that("valid_units errors if covariate not recognized", {
  expect_error(valid_units("foo"))
})

test_that("valid units for scr are consistent", {
  expect_equal(
    valid_units("scr"),
    c(
      "mg/dl",
      "mg_dl",
      "micromol/l",
      "micromol_l",
      "micromol",
      "mmol",
      "mumol/l",
      "umol/l",
      "mumol_l",
      "umol_l"
    )
  )
  ## If this test is failing it is because we have updated the valid units for
  ## scr. This test and comment are here to remind you to also update
  ## convert_creat_unit() with whatever new units we want to support!
})

test_that("valid units for alb are consistent", {
  expect_equal(
    valid_units("serum_albumin"),
    c(
      "g_l",
      "g/l",
      "g_dl",
      "g/dl",
      "micromol/l",
      "micromol_l",
      "micromol",
      "mmol",
      "mumol/l",
      "umol/l",
      "mumol_l",
      "umol_l"
    )
  )
  ## If this test is failing it is because we have updated the valid units for
  ## serum_albumin. This test and comment are here to remind you to also update
  ## convert_albumin_unit() with whatever new units we want to support!
})
