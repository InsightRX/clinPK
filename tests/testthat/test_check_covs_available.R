test_that('returns false for missing', {
  expect_false(
    check_covs_available(c('height'), list(height = NULL), verbose = FALSE)
  )
})
test_that("returns true for not missing", {
  expect_true(
    check_covs_available(c('height'), list(height = 9), verbose = FALSE)
  )
})
