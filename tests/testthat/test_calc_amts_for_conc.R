test_that("Amounts are calculated", {
  A1 <- calc_amts_for_conc(10, parameters = list(CL = 10, V = 50), n_cmt = 1)
  A2 <- calc_amts_for_conc(10, parameters = list(CL = 10, V = 50, V2 = 150), n_cmt = 2)
  A3 <- calc_amts_for_conc(10, parameters = list(CL = 10, V = 50, V2 = 150, V3 = 80), n_cmt = 3)

  expect_equal(A1, 500)
  expect_equal(A2, c(500, 1500))
  expect_equal(A3, c(500, 1500, 800))
})
