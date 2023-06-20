test_that("calvert eqn with egfr supplied", {
  expect_equal(calc_carboplatin_calvert(5, 100), 700)
  expect_equal(calc_carboplatin_calvert(4, 30), 224)
})

test_that("calvert eqn with egfr supplied", {
  expect_equal(
    calc_carboplatin_calvert(
      5, 
      sex = "male", 
      age = 50, 
      scr = 1.1, 
      weight = 70,
      verbose = FALSE
    ), 
    577.27273
  )
})
