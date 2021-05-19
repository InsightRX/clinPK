test_that("add RUV all 0", {
  expect_equal(add_ruv(1:100,ruv = list(prop = 0, add = 0, exp = 0)), 1:100)
})

test_that("add RUV prop err", {
  expect_true(
    all(add_ruv(1:100, ruv = list(prop = 0.1, add = 0, exp = 0)) != 1:100)
  )
})

test_that("add RUV prop err", {
  expect_true(
    abs(
      1 - mean(add_ruv(1:100, ruv = list(prop = 0.1, add = 0, exp = 0)) / 1:100)
    ) < 0.04
  )
})

test_that("add RUV add err", {
  expect_true(
    all(add_ruv(1:100, ruv = list(prop = 0, add = 0.1, exp = 0)) != 1:100)
  )
})

test_that("add RUV exp err", {
  expect_true(
    all(add_ruv(1:100, ruv = list(prop = 0, add = 0, exp = 0.1)) != 1:100)
  )
})
