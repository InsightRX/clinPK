test_that("parses legacy typos", {
  expect_equal(names(egfr_cov_reqs("cockroft-gault")), "cockcroft_gault")
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
