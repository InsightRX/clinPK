test_that("FFM calculation works", {
  expect_equal(round(calc_ffm(weight = 80, bmi = 20, sex = "male")$value), 67)
  expect_equal(round(calc_ffm(weight = 80, bmi = 30, sex = "male")$value), 56)
  expect_equal(round(calc_ffm(weight = 80, bmi = 30, sex = "female")$value), 46)
  expect_equal(
    round(
      calc_ffm(
        weight = 60, height = 140, age = 12, sex = "female", method = "al-sallami"
      )$value
    ),
    36
  )
})

test_that("vectorization over different sex values works for all methods", {
  methods <- c(
    "janmahasatian",
    "green",
    "al-sallami",
    "storset",
    "bucaloiu",
    "hume",
    "james",
    "garrow_webster"
  )

  # suppressWarnings is for "bucaloiu" method, which is only meant for obese females.
  for (m in methods) {
    male_val <- suppressWarnings(calc_ffm(
      method = m, sex = "male", weight = 80, bmi = 20, height = 170, age = 30
    )$value)
    female_val <- suppressWarnings(calc_ffm(
      method = m, sex = "female", weight = 80, bmi = 20, height = 170, age = 30
    )$value)
    vec_val <- suppressWarnings(calc_ffm(
      method = m, sex = c("male", "female"), weight = c(80, 80),
      bmi = c(20, 20), height = c(170, 170), age = c(30, 30)
    )$value)
    expect_equal(vec_val, c(male_val, female_val), label = paste("method:", m))
  }
})

test_that("vectorization propagates NAs in output", {
  # bmi:
  res1 <- calc_ffm(weight = c(80, 80), bmi = c(NA, 20), sex = c("male", "female"))$value
  expect_true(is.na(res1[1]))
  expect_false(is.na(res1[2]))
  # height:
  res2 <- calc_ffm(weight = c(80, 80), height = c(170, NA), sex = c("male", "female"))$value
  expect_false(is.na(res2[1]))
  expect_true(is.na(res2[2]))
  # weight:
  res3 <- calc_ffm(weight = c(80, NA), bmi = c(20, 20), sex = c("male", "female"))$value
  expect_false(is.na(res3[1]))
  expect_true(is.na(res3[2]))
  # age:
  res4 <- calc_ffm(
    weight = c(80, 80),
    height = c(170, 170),
    age = c(30, NA),
    sex = c("male", "female"),
    method = "al-sallami"
  )$value
  expect_false(is.na(res4[1]))
  expect_true(is.na(res4[2]))
})

test_that("calc_ffm() errors on mismatched vector lengths", {
  expect_error(
    calc_ffm(
      weight = c(80, 80), # length 2
      bmi = c(20, 20, 20), # length 3
      sex = "male"
    ),
    "Vector inputs must all be the same length: `weight` \\(size 2\\), `bmi` \\(size 3\\)\\."
  )
})

test_that("calc_ffm() errors if missing required covariates", {
  expect_error(
    calc_ffm(weight = 80, sex = "male"),
    "Method 'janmahasatian' requires: bmi or weight and height."
  )
  expect_error(
    calc_ffm(weight = 80, sex = "male", height = 180, method = "al-sallami"),
    "Method 'al-sallami' requires: age."
  )
  expect_error(
    calc_ffm(sex = "female", height = 180, method = "storset"),
    "Method 'storset' requires: weight"
  )
  expect_error(
    calc_ffm(method = "bucaloiu"),
    "Method 'bucaloiu' requires: weight, sex, height."
  )
  expect_error(
    calc_ffm(weight = 80, height = 150, method = "hume"),
    "Method 'hume' requires: sex."
  )
  expect_error(
    calc_ffm(method = "james"),
    "Method 'james' requires: weight, sex, height."
  )
  expect_error(
    calc_ffm(weight = 90, sex = "female", method = "garrow_webster"),
    "Method 'garrow_webster' requires: height."
  )
})

test_that("calc_ffm() warns and returns NULL if sex value not supported", {
  methods_with_sex <- c(
    "janmahasatian",
    "al-sallami",
    "storset",
    "hume",
    "james",
    "garrow_webster"
  )
  for (m in methods_with_sex) {
    expect_warning(
      expect_null(
        calc_ffm(
          weight = 80,
          sex = "unknown", # Unsupported value
          height = 150,
          bmi = 20,
          age = 20,
          method = m
        )
      ),
      label = paste("method:", m)
    )
  }
})

test_that("ffm_bucaloiu warns if used for other than obese females", {
  expect_warning(
    res1 <- calc_ffm(
      weight = 50, sex = "female", height = 150, age = 20, method = "bucaloiu"
    )$value,
    "This equation is only meant for obese females."
  )
  expect_equal(res1, 22.90)
  
  # Invalid sex is caught centrally before reaching ffm_bucaloiu():
  expect_warning(
    res2 <- calc_ffm(
      weight = 100, sex = "unknown", height = 150, age = 20, method = "bucaloiu"
    ),
    "This method requires sex to be one of 'male' or 'female'."
  )
  expect_null(res2)
})

test_that("ffm equations give expected values", {
  expect_equal(
    calc_ffm(
      weight = 80,
      sex = "male",
      height = 150,
      digits = 10
    )$value,
    51.643454
  )
  expect_equal(
    calc_ffm(
      weight = 80,
      sex = "male",
      height = 150,
      age = 20,
      method = "al-sallami",
      digits = 10
    )$value,
    51.605376
  )
  expect_equal(
    calc_ffm(
      weight = 80,
      sex = "male",
      height = 180,
      age = 20,
      method = "storset",
      digits = 10
    )$value,
    57.756004
  )
  expect_equal(
    suppressWarnings(calc_ffm(
      weight = 80,
      sex = "female",
      height = 150,
      age = 20,
      method = "bucaloiu",
      digits = 10
    ))$value, 
    33.5
  )
  expect_equal(
    calc_ffm(
      weight = 80,
      sex = "female",
      height = 150,
      method = "hume",
      digits = 10
    )$value,
    43.0814
  )
  expect_equal(
    calc_ffm(
      weight = 80,
      sex = "female",
      height = 150,
      method = "james",
      digits = 10
    )$value,
    43.502222
  )
  expect_equal(
    calc_ffm(
      weight = 80,
      sex = "female",
      height = 150,
      method = "garrow_webster",
      digits = 10
    )$value,
    44.875
  )
})
