test_that("calculates NP grades", {
  expect_equal(calc_neutropenia_grade(c(3000, 250, 500)), c(NA, 4, 3))
})
