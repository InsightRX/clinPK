test_that("BSA calculation is correct - dubois (default)", {
  expect_equal(round(calc_bsa(80, 180)$value, 3), 1.996)
  expect_equal(round(calc_bsa(80, 180, method = "dubois")$value, 3), 1.996)
})

test_that("BSA calculation is correct: Mosteller", {
  expect_equal(round(calc_bsa(80, 180, method = "mosteller")$value, 3), 2.000)
})

test_that("BSA calculation is correct: haycock", {
  expect_equal(round(calc_bsa(80, 180, method = "haycock")$value, 3), 2.007)
})

test_that("BSA calculation is correct: gehan_george", {
  expect_equal(round(calc_bsa(80, 180, method = "gehan_george")$value, 3), 2.009)
})

test_that("BSA calculation is correct: boyd", {
  expect_equal(round(calc_bsa(80, 180, method = "boyd")$value, 3), 2.007)
})

test_that("BSA argument input errors are checked", {
  expect_error(
    calc_bsa(80, 180, method = "crazy new equation"), 
    "'arg' should be one of"
  )
  expect_error(
    calc_bsa(80, height = NULL),
    "Height required"
  )
  expect_error(
    calc_bsa(weight = NULL, height = 180),
    "Weight required"
  )
})
