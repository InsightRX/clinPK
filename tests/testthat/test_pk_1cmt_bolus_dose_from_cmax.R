test_that("PK 1cmt bolus dose calculation",{
  expect_equal(
    round(
      pk_1cmt_bolus_dose_from_cmax(
        cmax = 10,
        tau = 24,
        CL = 10,
        V = 50
      ),
      1
    ),
    495.9
  )
})
