test_that("dose2auc empty call", {
  expect_error(dose2auc())
})

test_that("dose2auc ", {
  expect_equal(dose2auc(dose = 5000, CL=10, V=100), 500)
})

test_that("dose2auc partial auc", {
  expect_equal(
    round(dose2auc(dose = 9932, CL=10, V=100, t_auc = 7)),
    500
  )
})
