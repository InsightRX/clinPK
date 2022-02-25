test_that("missing sex or missing age throws error", {
  expect_error(pct_for_age_generic(age = 17, value = 167))
  expect_error(pct_for_age_generic(sex = "female", value = 167))
})

test_that("Age out of bounds returns NULL", {
  expect_null(
    suppressMessages(
      pct_for_age_generic(
        age = 21,
        sex = "female",
        value = 167,
        variable = "height"
      )
    )
  )
  expect_null(
    suppressMessages(
      pct_for_age_generic(
        age = 21,
        sex = "female",
        value = 167,
        variable = "weight"
      )
    )
  )
})

test_that("Correct percentiles: height", {
  pct1 <- pct_for_age_generic(
    age = 4, 
    sex = "female", 
    value = 100, 
    variable = "height"
  )
  pct2 <- pct_for_age_generic(
    age = 6, 
    sex = "male", 
    value = 120, 
    variable = "height"
  )
  expect_equal(pct1$percentile, 26.7)
  expect_equal(pct2$percentile, 79.1)
})

test_that("Correct percentiles: weight", {
  pct1 <- pct_for_age_generic(
    age = 4,
    sex = "female",
    value = 15,
    variable = "weight"
  )
  pct2 <- pct_for_age_generic(
    age = 6,
    sex = "male",
    value = 25,
    variable = "weight"
  )
  expect_equal(pct1$percentile, 31.2)
  expect_equal(pct2$percentile, 92)
})

test_that("Correct percentiles: bmi", {
  pct1 <- pct_for_age_generic(
    age = 4,
    sex = "male",
    value = 17,
    variable = "bmi"
  )
  pct2 <- pct_for_age_generic(
    age = 6,
    sex = "female",
    value = 17,
    variable = "bmi"
  )
  expect_equal(pct1$percentile, 88.9)
  expect_equal(pct2$percentile, 83.8)
})

test_that("extreme percentiles capped to min and max", {
  expect_message(
    pct1 <- pct_for_age_generic(
      age = 4,
      sex = "male",
      value = 1,
      variable = "weight"
    )
  )
  expect_message(
    pct2 <- pct_for_age_generic(
      age = 4,
      sex = "male",
      value = 100,
      variable = "weight"
    )
  )
  expect_equal(pct1$percentile, 0.1)
  expect_equal(pct2$percentile, 99.9)
})

test_that("percentiles right at 0.1 return a value", {
  res1 <- suppressMessages(
    pct_for_age_generic(
      age = 0.0349462365591398,
      sex = "female",
      value = 2.21,
      variable = "weight"
    )
  )
  expect_equal(res1, list(percentile = 0.1))
})
