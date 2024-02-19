test_that("wrong units throw an error", {
  expect_error(convert_albumin_unit(70, "g_l", "L/hr"))
  expect_error(convert_albumin_unit(70, "L/hr", "g_l"))
  expect_error(convert_albumin_unit(70, "g_l", NULL))
})

test_that("length mismatch throws error", {
  expect_error(convert_albumin_unit(70, NULL, "g_l"))
  expect_error(convert_albumin_unit(c(70, 7, 77), c("g_dl", "g_l"), "g_l"))
})

test_that("vectorized conversion works", {
  res <- convert_albumin_unit(c(70, 7), "g_dl", "g_l")
  expect_equal(
    res,
    list(value = c(700, 70), unit = "g_l")
  )
})

test_that("basic conversions work", {
  expect_equal(
    convert_albumin_unit(c(60, 6), c("g_l", "g_dl"), "g_dl"), 
    list(value = c(6, 6), unit = "g_dl")
  )
  expect_equal(
    convert_albumin_unit(c(60, 6), c("g_l", "g_dl"), "g_l"), 
    list(value = c(60, 60), unit = "g_l")
  )
  expect_equal(
    convert_albumin_unit(10, "micromol_l", "g_l"),
    list(value = .665, unit = "g_l")
  )
  expect_equal(
    convert_albumin_unit(c(10, 10), c("mumol_l", "umol_l"), "g_l"),
    list(value = c(.665, .665), unit = "g_l")
  )
})
