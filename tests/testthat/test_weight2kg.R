test_that("no value throws an error", {
  expect_error(weight2kg(NULL))
})

test_that("original weight is returned if given in kg", {
  expect_equal(weight2kg(50, "kg"), 50)
})

test_that("weight2kg errors if given no unit", {
  expect_error(weight2kg(50))
  expect_error(weight2kg(50, unit = NA))
  expect_error(weight2kg(50, unit = NULL))
})

test_that("weight2kg errors if unit not recognized", {
  expect_error(weight2kg(10, "stone"))
})

test_that("pounds are converted to kg", {
  expect_equal(weight2kg(150, "lb"), 68.038936)
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

test_that("weight2kg supports capitalized units", {
  expect_equal(weight2kg(1000, "G"), 1)
  expect_equal(weight2kg(10, "LB"), 4.53592909)
  expect_equal(weight2kg(5, "KG"), 5)
})

test_that("weight2kg is vectorized over units", {
  expect_equal(weight2kg(c(1000, 100), c("g", "lb")), c(1, 45.3592909))
  expect_equal(weight2kg(c(400, 500), c("oz", "oz")), c(11.3397970176, 14.1747462720))
})

test_that("weight2kg errors if any units are invalid", {
  expect_error(weight2kg(c(100, 100, 100), c("lb", "foo", "bar")))
})

test_that("normal R recycling happens if values and units are different length", {
  expect_warning(
    expect_equal(
      weight2kg(c(100, 100, 100), c("lb", "kg")),
      c(45.3592909, 100, 45.3592909)
    )
  )
  expect_equal(
    weight2kg(100, c("g", "kg")),
    c(0.1, 100)
  )
})
