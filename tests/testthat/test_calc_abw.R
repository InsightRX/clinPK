test_that("ABW with no height specified throws error", {
  expect_error(calc_abw(weight = 80, verbose = FALSE))
  expect_error(calc_abw(weight = NULL))
})

test_that("ABW calculation works", {
  expect_equal(
    round(calc_abw(weight = 80, height = 180, age = 50, verbose = FALSE), 1),
    77.0
  )
  expect_equal(
    round(calc_abw(weight = 150, height = 150, age = 20, verbose = FALSE), 1),
    88.7
  )
  expect_equal(round(calc_abw(weight = 50, ibw = 40, verbose = FALSE), 1), 44.0)
})
