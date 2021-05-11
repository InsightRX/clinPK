test_that("estimation of elimination rate", {
  dose <- 1000
  V <- 50
  kel <- 0.1
  CL <- kel * V
  conc <- pk_1cmt_inf_ss(
    t = 10,
    dose = 1000,
    tau = 12,
    t_inf = 1,
    CL = CL,
    V = V
  )
  kel_est <- calc_kel_single_tdm(
    dose = 1000,
    V = 50,
    t = 10,
    dv = 11.07,
    tau = 12,
    t_inf = 1,
    kel_init = .1,
    n_iter = 20
  )
  expect_true(abs(kel_est - kel)/kel < 0.05)
})
