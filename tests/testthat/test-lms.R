test_that("lms_for_x() works", {
  out <- lms_for_x(l = -0.1600954, m = 9.476500305, s = 0.11218624, z = -1.645)
  expect_equal(out, 7.9006292)
  out2 <- lms_for_x(
    l = -0.1600954, m = 9.476500305, s = 0.11218624, p = pnorm(-1.645)
  )
  expect_equal(out2, 7.9006292)
})

test_that("lms_for_x() works", {
  out <- lms_for_z(
    l = -0.1600954, m = 9.476500305, s = 0.11218624, x = 9.7, value = "p"
  )
  expect_equal(out, 58.215103)
  out <- lms_for_z(
    l = -0.1600954, m = 9.476500305, s = 0.11218624, x = 9.7, value = "z"
  )
  expect_equal(out, 0.20739941)
})
