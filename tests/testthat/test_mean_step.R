test_that("Mean step function works correcty", {
  x <- c(0, 5, 8, 12)
  expect_equal(
    mean_step(x),
    c(2.5, 6.5, 10.0)
  )
})
