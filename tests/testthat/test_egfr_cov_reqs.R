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
