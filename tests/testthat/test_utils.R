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
