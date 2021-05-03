test_that("Pct weight for age", {
  expect_equal(
    pct_weight_for_age(age = 1, weight = 9, sex="male")$percentile, 26.5
  )
  expect_equal(
    pct_weight_for_age(age = 1, weight = 9, sex="female")$percentile, 51.7
  )
  expect_true(
    length(names(pct_weight_for_age(age = 1, sex="male"))) > 12
  )
})

test_that("Pct weight for age errors", {
  expect_error(pct_weight_for_age(weight = 9, sex="male"))
  expect_error(pct_weight_for_age())
})
