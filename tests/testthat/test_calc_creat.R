test_that("calc_create calculates creatinine estimates", {
  expect_equal(
    calc_creat(
      sex = c("male", "female"),
      age = c(14, 14))$value,
     c(53.1,53.1)
  )
  expect_equal(
    calc_creat(
      sex = c("male", "female"),
      age = c(14, 14))$method,
    "johanssen"
  )
  expect_equal(
    calc_creat(
      sex = c("male", "female"),
      age = c(16, 16))$value,
    c(64.9,60.1)
  )
  expect_equal(
    calc_creat(
      sex = c("male", "female"),
      age = c(16, 40))$method,
    "johanssen"
  )
  expect_equal(
    calc_creat(
      sex = c("male", "female"),
      age = c(50,50),
      weight = c(75,75),
      height = c(165,165),
      adult_method = "brooks")$value,
    c(83.6, 68.2)
  )
  expect_equal(
    calc_creat(
      sex = c("female", "female"),
      age = c(20,80),
      weight = c(50,120),
      height = c(120,200),
      adult_method = "brooks")$value,
    c(40.1, 94.1)
  )
  expect_equal(
    calc_creat(
      sex = c("male", "male"),
      age = c(20,80),
      weight = c(50,120),
      height = c(120,200),
      adult_method = "brooks")$value,
    c(55.5, 109.4)
  )
  expect_equal(
    calc_creat(
      sex = c("male", "male"),
      age = c(20,80),
      weight = c(50,120),
      height = c(120,200),
      adult_method = "brooks")$method,
    "brooks"
  )
  expect_equal(
    calc_creat(
      sex = c("male", "male"),
      age = c(20,80),
      weight = c(50,120),
      height = c(120,200),
      adult_method = "brooks")$unit,
    "micromol/L"
  )
  expect_error(
    calc_creat(
      age = 50,
      weight = 70,
      height = 160,
      adult_method = "brooks"),
    "Sex needs to be either male or female!"
    )
  expect_error(
    calc_creat(
      sex = 'male',
      weight = 70,
      height = 160,
      adult_method = "brooks"),
    "Age required"
  )
  expect_error(
    calc_creat(
      sex = 'male',
      age = 50,
      height = 160,
      adult_method = "brooks"),
    "Weight is required"
  )
  expect_error(
    calc_creat(
      sex = 'male',
      age = 50,
      weight = 70,
      adult_method = "brooks"),
    "Height is required"
  )
})

  