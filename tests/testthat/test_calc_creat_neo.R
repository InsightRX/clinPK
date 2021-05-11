test_that("calc_creat_neo errors if PMA is NULL", {
  expect_error(calc_creat_neo(pma = NULL))
})

test_that("errors if PMA < 25", {
  expect_error(calc_creat_neo(pma = 5))
  expect_error(calc_creat_neo(pma = c(5, 25, 30)))
})

test_that("errors if PMA > 42", {
  expect_error(calc_creat_neo(pma = 43))
  expect_error(calc_creat_neo(pma = c(30, 40, 50)))
})

test_that("calculates expected serum creatinine values", {
  expect_equal(
    calc_creat_neo(30),
    list(value = 81, unit = "micromol/L")
  )
})

test_that("calc_creat_neo can accept vector of PMAs", {
  expect_equal(
    calc_creat_neo(c(26, 27, 40)),
    list(value = c(92.4, 89.6, 52.5), unit = "micromol/L")
  )
})

test_that("calc_creat_neo rounds to given number of digits", {
  expect_equal(
    calc_creat_neo(30, digits = 2),
    list(value = 81.01, unit = "micromol/L")
  )
  expect_equal(
    calc_creat_neo(35, digits = 3),
    list(value = 66.765, unit = "micromol/L")
  )
  expect_equal(
    calc_creat_neo(c(25, 26), digits = 2),
    list(value = c(95.25, 92.41), unit = "micromol/L")
  )
})
