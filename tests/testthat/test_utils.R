test_that("remove_lt_gt() removes <, >, =, space", {
  expect_equal(
    remove_lt_gt(c("<0.2", ">100", "<=1", "> 5")),
    c(0.2, 100, 1, 5)
  )
})

test_that("remove_lt_gt() preserves NAs", {
  expect_equal(
    remove_lt_gt(c("<0.2", NA)),
    c(0.2, NA)
  )
})

test_that("remove_lt_gt() returns original if couldn't convert", {
  expect_equal(
    remove_lt_gt(c("#5", "6 test", "<3", "1.5.5")),
    c("#5", "6test", "3", "1.5.5")
  )
})

test_that("remove_lt_gt() removes repeated instances of character", {
  expect_equal(remove_lt_gt("<    0.2"), 0.2)
})

test_that("remove_lt_gt() returns NULL if provided NULL", {
  expect_null(remove_lt_gt(NULL))
})

test_that("remove_lt_gt() returns original values if passed numeric vector", {
  expect_equal(remove_lt_gt(0.2), 0.2)
})

test_that("remove_lt_gt() leaves negative numbers alone", {
  expect_equal(remove_lt_gt("-<0.6"),  -0.6)
})

test_that("%>=% operator works", {
  expect_true((0.7 - 0.4) %>=% 0.3)
})

test_that("%<=% operator works", {
  expect_true((0.1 + 0.2) %<=% 0.3)
})

test_that("%>=% operator works on vectors", {
  res <- c(1, 2, 3, 4) %>=% c(0, 3, 1, 5)
  expect_equal(res, c(TRUE, FALSE, TRUE, FALSE))
})

test_that("%>=% operator handles NAs like >=", {
  expect_true(is.na(5 %>=% NA))
  expect_true(is.na(NA %>=% 6))
  res <- c(1, NA) %>=% 0
  expect_equal(res, c(TRUE, NA))
})

test_that("%>=% operator handles vectors of different lengths", {
  expect_equal(2 %>=% c(1, 3), c(TRUE, FALSE))
  expect_equal(c(1, 3) %>=% 2, c(FALSE, TRUE))
})

test_that("%>=% handles zero-length input", {
  expect_equal(c(1, 3) %>=% numeric(0), logical(0))
  expect_equal(numeric(0) %>=% 5, logical(0))
})

test_that("%<=% handles zero-length input", {
  expect_equal(c(1, 3) %<=% numeric(0), logical(0))
  expect_equal(numeric(0) %<=% 5, logical(0))
})
