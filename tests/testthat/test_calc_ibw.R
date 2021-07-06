test_that("IBW errors when no height specified", {
  expect_error(calc_ibw(weight = 80))
  expect_error(calc_ibw(weight = NULL))
})

test_that("IBW calculation works", {
  expect_equal(round(calc_ibw(height = 180, age = 50), 1), 75.0)
  expect_equal(round(calc_ibw(height = 150, age = 20), 1), 47.8)
})

test_that("calc_ibw() throws error if weight is missing but needed", {
  expect_error(calc_ibw(age = 0.03, height = 40))
})
