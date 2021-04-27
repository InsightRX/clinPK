test_that("convert_creat_unit converts correctly", {
  expect_equal(
    round(convert_creat_unit(84, unit_in = "micromol/L")$value, 3),
    0.95
  )
  expect_equal(
    round(convert_creat_unit(1.2, unit_in = "mg/dL")$value,3),
    106.104
  )
  expect_equal(round(convert_creat_unit(1.2)$value,3), 106.104)
})
