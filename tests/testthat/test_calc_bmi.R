test_that("calc_bmi errors if no height specified", {
  expect_error(calc_bmi(weight = 80))
})

test_that("BMI calculation works", {
  expect_equal(round(calc_bmi(weight = 80, height = 180), 1), 24.7)
  expect_equal(round(calc_bmi(weight = 50, height = 130), 1), 29.6)
})
