test_that("Dosing weight is calculated", {
  expect_equal(
    round(
      calc_dosing_weight(
        weight = 160,
        height = 160,
        age= 50,
        sex = "female",
        verbose = FALSE
      )$value,
      1
    ),
    95.4
  )
  expect_equal(
    round(
      calc_dosing_weight(
        weight = 60,
        height = 160,
        age= 50,
        sex = "female",
        verbose = FALSE
      )$value,
      1
    ),
    52.4
  )
  expect_equal(
    round(
      calc_dosing_weight(
        weight = 50,
        height = 160,
        age= 50,
        sex = "female",
        verbose = FALSE
      )$value,
      1
    ),
    50
  )
})

test_that("Dosing weight is calculated (vectorized)", {
  expect_equal(
    round(
      calc_dosing_weight(
        weight = c(160, 60, 50),
        height = 160,
        age= 50,
        sex = "female",
        verbose = FALSE
      )$value,
      1
    ),
    c(95.4, 52.4, 50)
  )
})

test_that("vectorization over different sex values works", {
  male_val <- calc_dosing_weight(
    weight = 80, height = 170, age = 40, sex = "male",   verbose = FALSE
  )$value
  female_val <- calc_dosing_weight(
    weight = 80, height = 170, age = 40, sex = "female", verbose = FALSE
  )$value
  vec_val <- calc_dosing_weight(
    weight = c(80, 80), height = c(170, 170), age = c(40, 40),
    sex = c("male", "female"), verbose = FALSE
  )$value
  expect_equal(vec_val, c(male_val, female_val))
})
