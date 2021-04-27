test_that("auc2dose empty call", {
  expect_error(auc2dose())
})

test_that("auc2dose ", {
  expect_equal(auc2dose(auc = 500, CL=10, V=100), 5000)
})

test_that("auc2dose partial auc", {
  expect_equal(round(auc2dose(auc = 500, CL=10, V=100, t_auc = 7)), 9932)
})
