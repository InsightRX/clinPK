test_that("LBW errors if no height specified", {
  expect_error(calc_lbw(weight = 80, sex = "female"))
  expect_error(calc_lbw(weight = NULL, sex = "female"))
  expect_error(calc_lbw(weight = 80, height=180))
})

test_that("LBW calculation works", {
  expect_equal(
    round(calc_lbw(weight = 80, height = 180, sex = "female")$value, 1),
    56.4
  )
  expect_equal(
    round(calc_lbw(weight = 50, height = 150, sex = "male")$value, 1),
    40.8
  )
  expect_true(
    class(calc_lbw(weight = 50, height = 150, sex = "male")) == "list"
  )
})

test_that("LBW calculation works, boer", {
  expect_equal(
    calc_lbw(weight = 65, height = 155, sex = "male", method = "boer")$value,
    48.6
  )
  expect_equal(
    calc_lbw(weight = 65, height = 155, sex = "female", method = "boer")$value,
    41.4
  )
})

test_that("vectorization over different sex values works for all methods", {
  methods <- c("green", "boer", "james", "hume")

  for (m in methods) {
    male_val <- calc_lbw(method = m, sex = "male", weight = 80, height = 170)$value
    female_val <- calc_lbw(method = m, sex = "female", weight = 80, height = 170)$value
    vec_val <- calc_lbw(
      method = m, sex = c("male", "female"),
      weight = c(80, 80), height = c(170, 170)
    )$value
    expect_equal(vec_val, c(male_val, female_val), label = paste("method:", m))
  }
})

test_that("calc_lbw() errors on mismatched vector lengths", {
  expect_error(
    calc_lbw(
      sex = c("male", "female"),
      weight = c(80, 80, 80),
      height = 170
    ),
    "Vector inputs must all be the same length: `sex` \\(size 2\\), `weight` \\(size 3\\)\\."
  )
})
