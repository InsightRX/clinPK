test_that("convert_bilirubin_units gives expected results", {
  expect_equal(
    convert_bilirubin_unit(1, "mg_dl", "micromol_l")$value,
    17.1035776
  )
  expect_equal(
    convert_bilirubin_unit(17.1035776, "micromol_l", "mg_dl")$value,
    1
  )
})

test_that("vectorized input works", {
  res <- convert_bilirubin_unit(
    c(1, 1.1, 1.2),
    unit_in = "mg_dl",
    unit_out = "micromol_l"
  )
  expect_equal(
    res$value,
    c(17.1035776, 18.8139353, 20.5242931)
   )
})

test_that("units are validated", {
  expect_error(convert_bilirubin_unit(1, "foo", "mg_dl"))
  expect_error(convert_bilirubin_unit(1, "mg_dl", "foo"))
})
