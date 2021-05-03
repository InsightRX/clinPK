test_that("PK 1cmt infusion dose calculation", {
  expect_equal(
    round(
      pk_1cmt_inf_dose_from_cmin(
        cmin = .1,
        tau = 24,
        t_inf = 1,
        CL = 10,
        V = 50
      ),
      1
    ),
    544.3
  )
})
