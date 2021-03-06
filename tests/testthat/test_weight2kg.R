test_that("no value throws an error", {
  expect_error(weight2kg(NULL))
})

test_that("original weight is returned if given in kg (or no unit)", {
  expect_equal(weight2kg(50, "kg"), 50)
  expect_equal(expect_warning(weight2kg(50)), 50)
  expect_equal(expect_warning(weight2kg(50, unit = NA)), 50)
})

test_that("original weight is returned if unit not recognized", {
  expect_equal(expect_warning(weight2kg(10, "stone")), 10)
})

test_that("pounds are converted to kg", {
  expect_equal(weight2kg(150, "lbs"), 68.038936)
  expect_equal(weight2kg(150, "pounds"), 68.038936)
  expect_equal(weight2kg(150, "pound"), 68.038936)
})

test_that("ounces are converted to kg", {
  expect_equal(weight2kg(64, "oz"), 1.8143675)
  expect_equal(weight2kg(64, "ounces"), 1.8143675)
  expect_equal(weight2kg(64, "ounce"), 1.8143675)
})

test_that("vectorized input works", {
  expect_equal(
    weight2kg(c(64, 65, 120), "oz"),
    c(1.8143675, 1.8427170, 3.4019391)
  )
  expect_equal(
    weight2kg(c(9, 10), 'lbs'),
    c(4.0823362, 4.5359291)
  )
})

test_that("weight2kg supports grams as input unit", {
  expect_equal(weight2kg(1000, "g"), 1)
})
