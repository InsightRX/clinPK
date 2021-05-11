test_that("calc_create calculates creatinine estimates", {
  expect_equal(
    calc_creat(
      sex = c("male", "female"),
      age = c(20,20)
    )$value,
    c(84.0, 69.5)
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
