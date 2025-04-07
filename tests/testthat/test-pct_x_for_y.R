test_that("pct_weight_for_age() works", {
  out <- pct_weight_for_age(
    weight = 6,
    age = 0.29,
    age_units = "years",
    sex = "male",
    return_numeric = TRUE
  )
  expect_equal(out, 31.491085)
})

test_that("pct_height_for_age() works", {
  out <- pct_height_for_age(
    height = 61,
    age = 0.29,
    age_units = "years",
    sex = "male",
    return_numeric = TRUE
  )
  expect_equal(out, 33.828905)
})

test_that("pct_bmi_for_age() works", {
  out <- pct_bmi_for_age(
    bmi = 16,
    age = 2.3,
    age_units = "years",
    sex = "male",
    return_numeric = TRUE
  )
  expect_equal(out, 37.625525)
})

test_that("pct_weight_for_height() works", {
  out <- pct_weight_for_height(
    weight = 6,
    height = 61,
    height_units = "centimetres",
    sex = "male",
    population = "infants",
    return_numeric = TRUE
  )
  expect_equal(out, 38.720054)
})
