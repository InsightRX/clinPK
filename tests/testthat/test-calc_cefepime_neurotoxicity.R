test_that("cefepime neurotoxicity calculation is correct", {
  expect_equal(signif(calc_cefepime_neurotoxicity(12), 2), .25)
  expect_equal(signif(calc_cefepime_neurotoxicity(16), 2), .50)
})
