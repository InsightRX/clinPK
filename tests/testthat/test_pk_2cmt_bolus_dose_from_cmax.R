test_that("PK 2cmt bolus dose calculation", {
  expect_equal(
    round(
      pk_2cmt_bolus_dose_from_cmax(
        cmax = 10,
        tau = 24,
        CL = 10,
        V = 50,
        Q = 5,
        V2 = 100
      ),
      1
    ),
    472.5
  )
})
