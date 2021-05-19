test_that("time_to_ss errors if elimination rate and half life are missing", {
  expect_error(time_to_ss(kel = NULL, halflife = NULL))
})

test_that("time_to_ss errors if in_doses = TRUE and tau is NULL", {
  expect_error(time_to_ss(halflife = 16, in_doses = TRUE, tau = NULL))
})

test_that("kel determined from halflife if NULL", {
  expect_equal(time_to_ss(kel = NULL, halflife = 12), 39.863137)
})

test_that("if in_doses = TRUE, divides by dosing interval", {
  tau <- 12
  t <- time_to_ss(halflife = 10, in_doses = TRUE, tau = tau)
  expect_equal(
    t * tau,
    time_to_ss(halflife = 10, in_doses = FALSE)
  )
})

test_that("time_to_ss returns time based on kel if provided", {
  expect_equal(time_to_ss(kel = 0.05), 46.051702)
  expect_equal(time_to_ss(kel = 0.05), time_to_ss(kel = 0.05, halflife = 1000))
})

test_that("time_to_ss errors if ss >= 1", {
  expect_error(time_to_ss(halflife = 12, ss = 1))
})
