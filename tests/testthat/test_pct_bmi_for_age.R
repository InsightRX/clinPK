test_that("Pct bmi for age", {
  expect_equal(pct_bmi_for_age(age = 2, bmi = 16, sex = "male")$percentile, 57.7)
  expect_equal(pct_bmi_for_age(age = 6, bmi = 16, sex = "female")$percentile, 66.1)
})
