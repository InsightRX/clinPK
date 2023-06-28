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

test_that("calvert eqn uses absolute egfr", {
  expect_equal(
    round(
      calc_carboplatin_calvert(
        5, 
        sex = "male", 
        age = 5, 
        scr = 1.1, 
        weight = 15,
        height = 90,
        method = "schwartz_revised",
        verbose = FALSE
      ),
      2
    ), 
    169.49
  )
})
