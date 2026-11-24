test_that("parses legacy typos", {
  expect_equal(names(egfr_cov_reqs("cockroft-gault")), "cockcroft_gault")
})

test_that("aliases are normalized", {
  expect_equal(names(egfr_cov_reqs("lund_malmo_rev")), "malmo_lund_revised")
})

test_that("CG returns expected covs", {
  expect_equal(
    egfr_cov_reqs("cockroft-gault")[[1]],
    c("creat", "age", "weight", "sex")
  )
})

test_that("schwartz_revised returns expected covs", {
  expect_equal(
    egfr_cov_reqs("schwartz_revised")[[1]],
    c("creat", "age", "sex", "height")
  )
})

test_that("EKFC returns expected covs", {
  expect_equal(egfr_cov_reqs("ekfc")[[1]], c("creat", "sex", "age"))
})

test_that("unknown methods error", {
  expect_error(egfr_cov_reqs("foo"), "method not recognized")
  expect_error(egfr_cov_reqs(NULL), "egfr method unspecified")
})

test_that("BSA is only required when converting between absolute and relative", {
  # jelliffe is relative, so only needs BSA for absolute eGFR
  expect_equal(egfr_cov_reqs("jelliffe")[[1]], c("creat", "sex", "age"))
  expect_true("bsa" %in% egfr_cov_reqs("jelliffe", relative = FALSE)[[1]])

  # jelliffe_unstable is absolute, so only needs BSA for relative eGFR
  expect_false("bsa" %in% egfr_cov_reqs("jelliffe_unstable")[[1]])
  expect_true("bsa" %in% egfr_cov_reqs("jelliffe_unstable", relative = TRUE)[[1]])

  # wright uses BSA in the equation itself
  expect_true("bsa" %in% egfr_cov_reqs("wright")[[1]])
  expect_true("bsa" %in% egfr_cov_reqs("wright", relative = FALSE)[[1]])
})
