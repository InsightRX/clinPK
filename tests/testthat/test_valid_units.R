test_that("valid_units returns valid units", {
  expect_equal(valid_units("age"), c("yrs", "weeks", "days", "years"))
  expect_equal(valid_units("height"), c("cm", "inch", "inches", "in"))
})

test_that("valid_units errors if covariate not recognized", {
  expect_error(valid_units("foo"))
})
