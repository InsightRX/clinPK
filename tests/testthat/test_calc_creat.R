test_that("calc_create calculates creatinine estimates", {
  expect_equal(
    suppressWarnings(calc_creat(
      sex = c("male", "female"),
      age = c(20,20)
    )$value),
    c(72.6, 57.2)
  )
  expect_equal(
    suppressWarnings( calc_creat(
      sex = c("male", "female"),
      age = c(80,80)
    )$value),
    c(94.7, 79.3)
  )
  expect_equal(
    suppressWarnings(calc_creat(
      sex = c("male", "female"),
      age = c(50,50),
    )$value),
    c(83.6, 68.2)
  )
  expect_equal(
    calc_creat(
      sex = c("male", "female"),
      age = c(50,50),
      wt = c(50,50),
      ht = c(120,120)
    )$value,
    c(66.5, 51.1)
  )
  expect_equal(
    calc_creat(
      sex = c("male", "female"),
      age = c(50,50),
      wt = c(120,120),
      ht = c(200,200)
    )$value,
    c(98.4, 83.0)
  )
  expect_equal(
    calc_creat(
      sex = c("male", "female"),
      age = c(50,50),
      wt = c(50,50),
      ht = c(120,120)
    )$value,
    c(66.5, 51.1)
  )
  expect_equal(
    calc_creat(
      sex = c("male", "female"),
      age = c(16,16)
    )$value,
    c(64.9, 60.1)
  )
  expect_equal(
    calc_creat(
      sex = c("male", "female"),
      age = c(16,14)
    )$value,
    c(64.9, 53.1)
  )
})
