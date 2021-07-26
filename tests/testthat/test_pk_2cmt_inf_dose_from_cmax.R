test_that("PK 2cmt infusion dose from cmax", {
  # This uses Thomson (2009) model covariates for an 80 kg patient
  # with CRCL 66 ml/min, with expectations tested against
  # that model simulated in PKPDsim
  dose <- pk_2cmt_inf_dose_from_cmax(
    cmax = 36.4,
    tau = 12,
    t_inf = 2,
    CL = 2.99,
    V = 54,
    Q = 2.28,
    V2 = 58.56
  )
  
  expect_equal(
    round(dose), 
    1000
  )
})
