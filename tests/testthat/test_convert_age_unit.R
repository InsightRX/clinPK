test_that("convert_age_unit gives correct values", {
  expect_equal(
    convert_age_unit(7, "days", "weeks"),
    list(value = 1, unit = "weeks")
  )
  expect_equal(
    convert_age_unit(365, "days", "years"),
    list(value = 1, unit = "years")
  )
  expect_equal(
    convert_age_unit(52, "weeks", "years"),
    list(value = 1, unit = "years")
  )
  expect_equal(
    convert_age_unit(14, "days", "weeks"),
    list(value = 2, unit = "weeks")
  )
  expect_equal(
    convert_age_unit(5, "days", "days"),
    list(value = 5, unit = "days")
  )
})

test_that("unrecognized units throw an error", {
  expect_error(convert_age_unit(5, "days", "foo"))
  expect_error(convert_age_unit(5, "foo", "years"))
})

test_that("convert_age_unit returns NULL", {
  expect_equal(
    convert_age_unit(NULL, "days", "weeks"),
    list(value = NULL, unit = "weeks")
  )
})

test_that("multiple values and input units are ok (but only one output)", {
  expect_equal(
    convert_age_unit(c(1, 2, 1), c("weeks", "weeks", "years"), "days"),
    list(value = c(7, 14, 365), unit = "days")
  )

  expect_error(
    convert_age_unit(c(2, 1), c("weeks", "days"), c("days", "years"))
  )
})

test_that("errors if length of values vector not a multiple of unit_in vector", {
  expect_error(convert_age_unit(c(1, 2, 1), c("weeks", "years"), "days"))
})
