test_that("wrong units throw an error", {
  expect_error(convert_albumin_unit(70, "g_l", "L/hr"))
  expect_error(convert_albumin_unit(70, "L/hr", "g_l"))
  expect_error(convert_albumin_unit(70, "g_l", NULL))
})

test_that("length mismatch throws error", {
  expect_error(convert_albumin_unit(70, NULL, "g_l"))
  expect_error(convert_albumin_unit(c(70, 7), "g_dl", "g_l"))
})

test_that("basic conversions work", {
  expect_equal(
    convert_albumin_unit(c(60, 6), c("g_l", "g_dl"), "g_dl"), 
    c(6, 6)
  )
  expect_equal(
    convert_albumin_unit(c(60, 6), c("g_l", "g_dl"), "g_l"), 
    c(60, 60)
  )
})
