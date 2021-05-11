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
