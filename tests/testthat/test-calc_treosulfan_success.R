test_that("treatment success calculation is correct", {
  expect_equal(signif(calc_treosulfan_success(3863), 2), .79) # reported as .78 in paper
  expect_equal(signif(calc_treosulfan_success(4800), 2), .82)
  expect_equal(signif(calc_treosulfan_success(4829), 2), .82)
  expect_equal(signif(calc_treosulfan_success(6037), 2), .79)
})
