test_that("calculate egfr based on cystatin works", {
  expect_equal(
    round(calc_egfr_cystatin(1.3, unit_out = "ml/min")$value, 1),
    54.1
  )
  expect_equal(
    round(calc_egfr_cystatin(1.3, unit_out = "l/hr")$value, 2), 3.24
  )
  expect_equal(
    round(calc_egfr_cystatin(1.3, unit_out = "ml/hr")$value, 1), 3244.1
  )
  expect_equal(
    round(
      calc_egfr_cystatin(1.3, unit_out = "ml/min", method = "larsson")$value,
      1
    ), 55.5
  )
})
