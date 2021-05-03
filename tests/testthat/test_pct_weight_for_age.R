test_that("Pct weight for age", {
  expect_equal(
    pct_weight_for_age(age = 1, weight = 9, sex = "male")$percentile, 26.5
  )
  expect_equal(
    pct_weight_for_age(age = 1, weight = 9, sex = "female")$percentile, 51.7
  )
  expect_true(
    length(names(pct_weight_for_age(age = 1, sex = "male"))) > 12
  )
})

test_that("Pct weight for age errors", {
  expect_error(pct_weight_for_age(weight = 9, sex = "male"))
  expect_error(pct_weight_for_age())
  expect_error(pct_weight_for_age(age = NULL))
})

test_that("given multiple ages, pct_weight_for_age returns percentiles", {
  res <- pct_weight_for_age(age = c(5, 8), sex = "femal")
  expect_true(inherits(res, "data.frame"))
  expect_equal(
    names(res),
    c(
      "age",
      "P01",
      "P1",
      "P3",
      "P5",
      "P10",
      "P15",
      "P25",
      "P50",
      "P75",
      "P85",
      "P90",
      "P95",
      "P97",
      "P99",
      "P999"
    )
  )
  expect_equal(res$age, c(5, 8))
})

test_that("throws an error if multiple ages given and height is provided", {
  expect_error(pct_weight_for_age(c(8, 9), height = 120))
})

test_that("can return median for both single and vector input", {
  res1 <- pct_weight_for_age(
    age = 9,
    height = 137,
    sex = "female",
    return_median = TRUE
  )
  res2 <- pct_weight_for_age(
    age = c(6, 7, 8),
    sex = "male",
    return_median = TRUE
  )
  expect_equal(res1, 28.204)
  expect_equal(res2, c(20.901, 22.892, 25.167))
})
