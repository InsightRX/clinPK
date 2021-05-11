test_that("find_nearest_dose errors if no dose value", {
  expect_error(find_nearest_dose())
})

test_that("find_nearest_dose rounds dose/increment", {
  res1 <- find_nearest_dose(150, 100, type = "round")
  res2 <- find_nearest_dose(250, 100, type = "round")
  expect_equal(res1, 200)
  expect_equal(res2, 200)
})

test_that("find_nearest_dose uses floor/ceiling", {
  res1 <- find_nearest_dose(523, 50, type = "floor")
  res2 <- find_nearest_dose(523, 50, type = "ceiling")
  expect_equal(res1, 500)
  expect_equal(res2, 550)
})

test_that("find_nearest_dose errors if type isn't in round, floor, or ceiling", {
  expect_error(find_nearest_dose(500, type = "trunc"))
})

test_that("find_nearest_dose errors if increment is NULL", {
  expect_error(find_nearest_dose(100, increment = NULL))
})
