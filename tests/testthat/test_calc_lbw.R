test_that("LBW errors if no height specified", {
  expect_error(calc_lbw(weight = 80, sex = "female"))
  expect_error(calc_lbw(weight = NULL, sex = "female"))
  expect_error(calc_lbw(weight = 80, height=180))
})

test_that("LBW calculation works", {
  expect_equal(
    round(calc_lbw(weight = 80, height = 180, sex = "female")$value, 1),
    56.4
  )
  expect_equal(
    round(calc_lbw(weight = 50, height = 150, sex = "male")$value, 1),
    40.8
  )
  expect_true(
    class(calc_lbw(weight = 50, height = 150, sex = "male")) == "list"
  )
})
