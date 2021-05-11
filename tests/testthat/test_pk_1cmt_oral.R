test_that("1cmt oral", {
  expect_equal(round(sum(pk_1cmt_oral(KA = 1)$dv), 1), 52.3)
})

test_that("1cmt oral when KA = KEL", {
  expect_equal(round(sum(pk_1cmt_oral(KA = .1)$dv), 1), 35.2)
})
