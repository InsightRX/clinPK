test_that("convert_creat_unit converts correctly", {
  expect_equal(
    round(
      convert_creat_unit(
        84,
        unit_in = "micromol/L",
        unit_out = "mg/dL"
      )$value,
      3
    ),
    0.95
  )
  expect_equal(
    round(
      convert_creat_unit(
        1.2,
        unit_in = "mg/dL",
        unit_out = "micromol/L"
      )$value,
      3
    ),
    106.082
  )
})

test_that("convert_creat_unit supports vectorized input", {
  res1 <- convert_creat_unit(
    c(84, 85, 86),
    unit_in = "micromol/L",
    unit_out = "mg/dL"
  )
  res2 <- convert_creat_unit(
    c(84, 85, 1, 84),
    unit_in = c("micromol/L", "micromol/L", "mg/dL", "umol_l"),
    unit_out = "mg/dL"
  )
  expect_equal(
    res1,
    list(value = c(0.950208, 0.96152, 0.972832), unit = "mg/dl")
  )
  expect_equal(
    res2,
    list(value = c(0.950208, 0.96152, 1, 0.950208), unit = "mg/dl")
  )
})

test_that("unsupported creat units throw an error", {
  expect_error(convert_creat_unit(1, "foo", "mg/dl"))
  expect_error(convert_creat_unit(1, "mg/dl", "foo"))
})

test_that("convert_creat_unit errors if values and unit_in are mismatched length", {
  expect_error(
    convert_creat_unit(
      c(84, 85, 1),
      unit_in = c("micromol/L", "micromol/L"),
      unit_out = "mg/dL"
    )
  )
})
