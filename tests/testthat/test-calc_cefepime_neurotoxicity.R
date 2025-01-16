test_that("cefepime neurotoxicity calculation is correct", {
  expect_equal(signif(calc_cefepime_neurotoxicity(13.7), 2), .25)
  expect_equal(signif(calc_cefepime_neurotoxicity(17.8), 2), .50)
})
