test_that("convert_conc_unit can convert g/dl, g/l, mg/dl", {
  expect_equal(convert_conc_unit(1, "g_dl", "g_l")$value, 10)
  expect_equal(convert_conc_unit(1, "g_l", "g_dl")$value, 0.10)
  expect_equal(convert_conc_unit(1, "g_dl", "mg_dl")$value, 1000)
  expect_equal(convert_conc_unit(1, "mg_dl", "g_dl")$value, .001)
  expect_equal(convert_conc_unit(1, "mg_dl", "g_l")$value, 0.01)
  expect_equal(convert_conc_unit(1, "g_l", "mg_dl")$value, 100)
})

test_that("molecular weight required when converting molar units", {
  expect_error(convert_conc_unit(1, "mg_dl", "micromol_l"))
  expect_error(convert_conc_unit(1, "micromol_l", "mg_dl"))
  expect_error(
    convert_conc_unit(c(1, 1), c("mg_dl", "g_dl"), "micromol_l")
  )
})

test_that("molar unit conversion works", {
  expect_equal(convert_conc_unit(1, "mg_dl", "micromol_l", 0.5)$value, 20000)
})

test_that("vectorized input works", {
  expect_equal(
    convert_conc_unit(c(1, 10), c("g_dl", "g_l"), "mg_dl", 100)$value,
    c(1000, 1000)
  )
})

test_that("input checking works as expected", {
  expect_error(convert_conc_unit(1, "mg_dl", c("g_dl", "g_l")))
  expect_error(convert_conc_unit(c(1, 1), c("mg_dl", "mg_dl", "mg_dl"), "g_l"))
  expect_error(convert_conc_unit(1, "mg_dl", "foo"))
  expect_error(convert_conc_unit(c(1, 1), c("g_dl", "foo"), "mg_dl"))
})
