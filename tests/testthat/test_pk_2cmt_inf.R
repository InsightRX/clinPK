test_that("PK 2cmt infusion over time", {
  # This uses Thomson (2009) model covariates for an 80 kg patient
  # with CRCL 66 ml/min, with expectations tested against
  # that model simulated in PKPDsim
  res <- pk_2cmt_inf(
    t = 0:24,
    dose = 1000,
    tau = 12,
    t_inf = 2,
    CL = 2.99,
    V = 54,
    Q = 2.28,
    V2 = 58.56
  )
  expect_named(res, c("t", "dv"))
  expect_s3_class(res, "data.frame")
  expect_equal(res$t, 0:24)
  expect_equal(
    round(res$dv[1:5], 2), 
    c(0, 8.82, 16.84, 15.31, 13.95)
  )
  expect_equal(
    round(res$dv[13:18], 2), 
    c(7.14, 15.46, 23.03, 21.09, 19.36, 17.81)
  )
})

test_that("Add RUV to PK 2cmt infusion over time", {
  res <- pk_2cmt_inf(
    t = 0:24,
    dose = 1000,
    tau = 12,
    t_inf = 2,
    CL = 2.99,
    V = 54,
    Q = 2.28,
    V2 = 58.56
  )
  set.seed(2)
  res_ruv <- pk_2cmt_inf(
    t = 0:24,
    dose = 1000,
    tau = 12,
    t_inf = 2,
    CL = 2.99,
    V = 54,
    Q = 2.28,
    V2 = 58.56,
    ruv = list(prop = 0.15, add = 1.6)
  )
  expect_named(res_ruv, c("t", "dv"))
  expect_s3_class(res_ruv, "data.frame")
  expect_equal(res_ruv$t, 0:24)
  expect_false(any(res_ruv$dv[1:10] == res$dv[1:10]))
})
