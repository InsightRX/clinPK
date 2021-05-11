test_that("cm --> inch", {
  expect_equal(round(cm2inch(cm = 100), 2), 39.37)
})

test_that("inch --> cm", {
  expect_equal(round(inch2cm(inch = 39.37), 2), 100)
})

test_that("kg --> lbs", {
  expect_equal(round(kg2lbs(kg = 100), 2), 220.46)
})

test_that("lbs --> kg", {
  expect_equal(round(lbs2kg(lbs = 220.462), 2), 100)
})
