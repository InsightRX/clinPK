test_that("PK 2cmt infusion dose calculation", {
  expect_equal(
    round(
      pk_2cmt_inf_dose_from_cmin(
        cmin = .1,
        tau = 24,
        t_inf = 1,
        CL = 10,
        V = 50,
        Q = 5,
        V2 = 100
      ),
      1
    ),
    84.6
  )
})
