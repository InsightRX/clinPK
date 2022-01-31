test_that("IBW errors when no age specified", {
  expect_error(calc_ibw(weight = 80))
  expect_error(calc_ibw(weight = NULL))
})

test_that("IBW calculation works", {
  expect_equal(round(calc_ibw(height = 180, age = 50), 1), 75.0)
  expect_equal(round(calc_ibw(height = 150, age = 20), 1), 47.8)
})

test_that("calc_ibw() throws error if weight is missing but needed", {
  expect_error(calc_ibw(age = 0.03, height = 40))
})

test_that("calc_ibw() errors if method doesn't match allowed", {
  expect_error(calc_ibw(method_children = "foo"))
  expect_error(calc_ibw(method_adults = "foo"))
})

test_that("calc_ibw errors if passed a vector", {
  expect_error(
    calc_ibw(age = c(10, 20), sex = c("male", "female"), height = 100, 130)
  )
})

test_that("calc_ibw() uses weight when age < 1", {
  expect_message(
    expect_equal(
      calc_ibw(age = 0.5, weight = 7),
      7
    )
  )
})

test_that("ibw_standard warns if used for adults/missing age", {
  expect_warning(ibw_standard(age = 25, height = 100, sex = "male"))
  expect_warning(ibw_standard(age = NULL, height = 100, sex = "male"))
})

test_that("ibw_standard errors if missing data", {
  expect_error(ibw_standard(age = 10, height = NA, sex = "female"))
  expect_error(ibw_standard(age = 10, height = NULL, sex = "female"))
  expect_error(ibw_standard(age = 17, height = 165, sex = NULL))
  expect_error(ibw_standard(age = 17, height = 165, sex = NA))
})

test_that("ibw_standard returns NULL if sex isn't supported", {
  expect_warning(
    res <- ibw_standard(age = 17, height = 165, sex = "unknown")
  )
  expect_null(res)
})

test_that("ibw_standard doesn't require sex if height < 5ft", {
  expect_equal(ibw_standard(age = 14, height = 150), 37.125)
})

test_that("ibw_standard calculates correct IBW", {
  expect_equal(
    ibw_standard(age = 15, height = 160, sex = "female"),
    48.992126
  )
  expect_equal(
    ibw_standard(age = 15, height = 160, sex = "male"),
    45.792126
  )
})

test_that("ibw_devine only supports adults and requires age", {
  expect_error(ibw_devine(age = NULL))
  expect_warning(ibw_devine(age = 15, sex = "female", height = 150))
})

test_that("ibw_devine returns NA and message if missing data", {
  expect_error(ibw_devine(age = 20, height = NA, sex = "female"))
  expect_error(ibw_devine(age = 20, height = NULL, sex = "female"))
  expect_error(ibw_devine(age = 30, height = 165, sex = NULL))
  expect_error(ibw_devine(age = 30, height = 165, sex = NA))
})

test_that("ibw_devine returns NULL if sex isn't supported", {
  expect_warning(
    res <- ibw_devine(age = 30, height = 165, sex = "unknown")
  )
  expect_null(res)
})

test_that("ibw_devine calculates correct IBW", {
  expect_equal(
    ibw_devine(age = 20, height = 160, sex = "female"),
    52.381890
  )
  expect_equal(
    ibw_devine(age = 20, height = 160, sex = "male"),
    56.881890
  )
})
