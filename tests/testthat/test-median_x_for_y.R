test_that("median_weight_for_age() works", {
  out <- median_weight_for_age(
    age = 4.5,
    age_units = "months",
    sex = "male"
  )
  expect_equal(out, 7.0418364)
})

test_that("median_height_for_age() works", {
  out <- median_height_for_age(
    age = 4.5,
    age_units = "months",
    sex = "male"
  )
  expect_equal(out, 64.216864)
})

test_that("median_bmi_for_age() works", {
  out <- median_bmi_for_age(
    age = 28.5,
    age_units = "months",
    sex = "male"
  )
  expect_equal(out, 16.3433365)
})

test_that("median_weight_for_height() works", {
  out <- median_weight_for_height(
    height = 49.5,
    height_units = "centimetres",
    sex = "male",
    population = "infants"
  )
  expect_equal(out, 3.2452256)
})
