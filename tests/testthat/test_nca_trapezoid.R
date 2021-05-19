test_that("NCA trapezoid calculations work", {
  dat0 <- data.frame(time = c(0.5, 1, 2.5, 4), dv = c(10, 8, 5, 1))
  dat1 <- data.frame(time = c(0.5, 1, 2.5, 4), dv = c(10, 5, 5, 1))
  dat2 <- data.frame(time = c(0.5, 1, 2.5, 4), dv = c(10, 5.001, 5, 1))
  res0 <- nca_trapezoid(dat0)
  res1 <- nca_trapezoid(dat1)
  res2 <- nca_trapezoid(dat2)
  expect_equal(round(res0, 4), 17.7838)
  expect_true((abs(res1 - res2) / res1) < 0.0001)
})

test_that("nca_trapezoid works with same DV on 3 timepoints", {
  dat3 <- data.frame(time = c(0.5, 1, 3, 7, 12), dv = c(10, 5, 5, 5, 1))
  dat4 <- data.frame(time = c(0.5, 1, 3, 7, 12), dv = c(10, 5.001, 5, 4.999, 1))
  res3 <- nca_trapezoid(dat3)
  res4 <- nca_trapezoid(dat4)
  expect_true((abs(res3 - res4)/ res3) < 0.0001)
})

test_that("nca_trapezoid errors when data isn't available", {
  expect_error(nca_trapezoid(data.frame(time = NULL, dv = c(10, 5))))
  expect_error(nca_trapezoid(data.frame(time = c(0, 5), dv = NULL)))
})
