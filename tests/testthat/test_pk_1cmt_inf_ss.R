test_that("PK 1cmt iv steady state", {
  expect_equal(
    round(
      tail(
        pk_1cmt_inf_ss(dose = 100, tau = 12, t_inf = 2, CL = 5, V = 50),
        1
      )$dv,
      3
    ),
    0.954
  )
})
