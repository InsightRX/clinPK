test_that("pct_height_for_age errors if age not provided", {
  expect_error(pct_height_for_age(NULL))
})

test_that("given multiple ages, pct_height_for_age returns percentiles", {
  res <- pct_height_for_age(age = c(10, 12), sex = "female")
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
  expect_equal(res$age, c(10, 12))
})

test_that("given one age and height, returns percentile", {
  res <- pct_height_for_age(age = 10, height = 137, sex = "female")
  expect_equal(res$percentile, 40.5)
})

test_that("given one age and no height, returns list of percentiles", {
  res <- pct_height_for_age(age = 10, sex = "female")
  expect_true(inherits(res, "list"))
  expect_equal(
    names(res),
    c(
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
})

test_that("throws an error if multiple ages given and height is provided", {
  expect_error(pct_height_for_age(c(8, 9), height = 120))
})

test_that("can return median for both single and vector input", {
  res1 <- pct_height_for_age(
    age = 10,
    height = 137,
    sex = "female",
    return_median = TRUE
  )
  res2 <- pct_height_for_age(
    age = c(5, 10, 15),
    sex = "male",
    return_median = TRUE
  )
  expect_equal(res1, 138.636)
  expect_equal(res2, c(133.481, 137.78, 142.078))
})
