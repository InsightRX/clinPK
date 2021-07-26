test_that("PK 2cmt bolus at steady state", {
  # This uses Thomson (2009) model covariates for an 80 kg patient
  # with CRCL 66 ml/min, with expectations tested against
  # that model simulated in PKPDsim
  
  # Note that a time buffer of 0.001 was added due to
  # slight differences with PKPDsim implementation of "instantaneous" 
  res <- pk_2cmt_bolus_ss(
    t = 0:12 - 0.001, 
    dose = 1000,
    CL = 2.99,
    V = 54,
    Q = 2.28,
    V2 = 58.56
  )
  expect_named(res, c("t", "dv"))
  expect_s3_class(res, "data.frame")
  expect_equal(res$t, 0:12 - 0.001)
  expect_equal(
    round(res$dv[1:5], 2), 
    c(20.36, 36.37, 34.1, 32.06, 30.21)
  )
})

test_that("Add RUV to PK 2cmt infusion at steady state", {
  res <- pk_2cmt_bolus_ss(
    t = 0:24,
    dose = 1000,
    CL = 2.99,
    V = 54,
    Q = 2.28,
    V2 = 58.56
  )
  set.seed(2)
  res_ruv <- pk_2cmt_bolus_ss(
    t = 0:24,
    dose = 1000,
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
