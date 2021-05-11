test_that("pk_1cmt_bolus_cmin_ss calculates expected values", {
  res1 <- pk_1cmt_bolus_cmin_ss()
  res2 <- pk_1cmt_bolus_cmin_ss(dose = 200)
  res3 <- pk_1cmt_bolus_cmin_ss(tau = 6)
  res4 <- pk_1cmt_bolus_cmin_ss(CL = 5)
  res5 <- pk_1cmt_bolus_cmin_ss(V = 50)
  expect_equal(res1, 1.4367092)
  expect_equal(res2, 2.8734184)
  expect_equal(res3, 4.0545641)
  expect_equal(res4, 0.52172548)
  expect_equal(res5, 1.8967536)
})

test_that("pk_1cmt_bolus_cmin_ss can take vector of doses or parameters", {
  res1 <- pk_1cmt_bolus_cmin_ss(dose = c(100, 200, 300))
  expect_equal(res1, c(1.4367092, 2.8734184, 4.3101276))

  res2 <- pk_1cmt_bolus_cmin_ss(dose = 100, CL = c(3, 5))
  expect_equal(res2, c(1.43670920, 0.52172548))
})

test_that("residual variability is added if provided", {
  set.seed(229)
  res <- pk_1cmt_bolus_cmin_ss(ruv = list(prop = 0.1, add = 1, exp = 0))
  expect_equal(res, 1.39163627)
})
