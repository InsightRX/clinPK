test_that("FFM calculation works", {
  expect_equal(
    round(calc_ffm (
      weight = 80,
      bmi = 20,
      sex = "male"
    )$value),
    67
  )
  expect_equal(
    round(calc_ffm (
      weight = 80,
      bmi = 30,
      sex = "male"
    )$value),
    56
  )
  expect_equal(
    round(calc_ffm (
      weight = 80,
      bmi = 30,
      sex = "female"
    )$value),
    46
  )
  expect_equal(
    round(calc_ffm (
      weight = 60, height = 140, age = 12,
      sex = "female", method = "al-sallami"
    )$value),
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

test_that("ffm functions error if missing info", {
  expect_error(
    ffm_janmahasatian_green(weight = 80, sex = "male")
  )
  expect_error(
    ffm_al_sallami(weight = 80, sex = "male", height = 180, age = NULL)
  )
  expect_error(ffm_storset(weight = NULL, sex = "female", height = 180))
  expect_error(ffm_bucaloiu(weight = NULL, height = NULL, sex = NULL))
  expect_error(ffm_hume(weight = 80, sex = NULL, height = 150))
  expect_error(ffm_james(weight = NULL, sex = NULL, height = NULL))
  expect_error(ffm_garrow_webster(weight = 90, sex = "female", height = NULL))
})

test_that("ffm functions warn and return NULL if sex not supported", {
  expect_warning(
    expect_null(
      ffm_janmahasatian_green(weight = 80, sex = "unknown", height = 150)
    )
  )
  expect_warning(
    expect_null(
      ffm_al_sallami(weight = 80, sex = "unknown", height = 180, age = 20)
    )
  )
  expect_warning(
    expect_null(
      ffm_storset(weight = 80, sex = "unknown", height = 180, age = 20)
    )
  )
  expect_warning(
    expect_null(
      ffm_hume(weight = 80, sex = "unknown", height = 150)
    )
  )
  expect_warning(
    expect_null(
      ffm_james(weight = 80, sex = "unknown", height = 150)
    )
  )
  expect_warning(
    expect_null(
      ffm_garrow_webster(weight = 90, sex = "unknown", height = 150)
    )
  )
})

test_that("ffm_bucaloiu warns if used for other than obese females", {
  expect_warning(
    res1 <- ffm_bucaloiu(weight = 50, sex = "female", height = 150, age = 20)
  )
  expect_warning(
    res2 <- ffm_bucaloiu(weight = 100, sex = "unknown", height = 150, age = 20)
  )
  expect_equal(res1, 22.88)
  expect_equal(res2, 40.58)
})

test_that("ffm equations give expected values", {
  expect_equal(
    ffm_janmahasatian_green(weight = 80, sex = "male", height = 150),
    51.643454
  )
  expect_equal(
    ffm_al_sallami(weight = 80, sex = "male", height = 150, age = 20),
    51.605376
  )
  expect_equal(
    ffm_storset(weight = 80, sex = "male", height = 180, age = 20),
    57.756004
  )
  expect_equal(
    ffm_bucaloiu(weight = 80, sex = "female", height = 150, age = 20),
    33.5
  )
  expect_equal(
    ffm_hume(weight = 80, sex = "female", height = 150),
    43.0814
  )
  expect_equal(
    ffm_james(weight = 80, sex = "female", height = 150),
    43.502222
  )
  expect_equal(
    ffm_garrow_webster(weight = 80, sex = "female", height = 150),
    44.875
  )
})
