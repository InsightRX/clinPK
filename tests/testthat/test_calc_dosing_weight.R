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
