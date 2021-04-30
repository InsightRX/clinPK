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
