test_that("pk_1cmt_bolus_cmax_ss calculates expected values", {
  res1 <- pk_1cmt_bolus_cmax_ss()
  res2 <- pk_1cmt_bolus_cmax_ss(dose = 200)
  res3 <- pk_1cmt_bolus_cmax_ss(tau = 6)
  res4 <- pk_1cmt_bolus_cmax_ss(CL = 5)
  res5 <- pk_1cmt_bolus_cmax_ss(V = 50)
  expect_equal(res1, 4.7700425)
  expect_equal(res2, 9.5400851)
  expect_equal(res3, 7.3878974)
  expect_equal(res4, 3.8550588)
  expect_equal(res5, 3.8967536)
})

test_that("pk_1cmt_bolus_cmax_ss can take vector of doses or parameters", {
  res1 <- pk_1cmt_bolus_cmax_ss(dose = c(100, 200, 300))
  expect_equal(res1, c(4.7700425, 9.5400851, 14.3101276))

  res2 <- pk_1cmt_bolus_cmax_ss(dose = 100, CL = c(3, 5))
  expect_equal(res2, c(4.7700425, 3.8550588))
})

test_that("residual variability is added if provided", {
  set.seed(584)
  res <- pk_1cmt_bolus_cmax_ss(ruv = list(prop = 0.1, add = 1, exp = 0))
  expect_equal(res, 4.0897402)
})
