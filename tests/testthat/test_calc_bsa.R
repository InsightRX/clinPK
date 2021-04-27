test_that("BSA calculation is correct", {
  expect_equal(round(calc_bsa(80, 180)$value, 2), 2.00)
})
