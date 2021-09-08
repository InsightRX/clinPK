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
