test_that("wrong units throw an error", {
  expect_error(convert_flow_unit(70, "kg/hr", "L/hr", weight = 50))
  expect_error(convert_flow_unit(70, "L/hr", "kg", weight = 50))
})

test_that("basic conversions work", {
  expect_equal(convert_flow_unit(60, "L/hr", "ml/min"), 1000)
  expect_equal(convert_flow_unit(1, "L/min", "ml/min"), 1000)
  expect_equal(convert_flow_unit(60, "mL/hr", "ml/min"),  1)
  expect_equal(convert_flow_unit(10, "ml/MIN", "l/HR"), 0.6)
})

test_that("to/from day conversions work", {
  expect_equal(convert_flow_unit(10, "L/hr", "L/day"), 240)
  expect_equal(convert_flow_unit(240, "L/day", "L/hr"), 10)
})

test_that("weight-based conversions work", {
  expect_equal(convert_flow_unit(100, "L/hr", "L/hr/kg", weight = 50), 2)
  expect_equal(convert_flow_unit(2, "L/hr/kg", "L/hr", weight = 50), 100)
  expect_equal(convert_flow_unit(600, "L/hr", "ml/min/kg", weight = 50), 200)
  expect_equal(convert_flow_unit(1, "mL/min/kg", "L/hr", weight = 50), 3)
})

test_that("vector input works", {
  expect_equal(
    round(
      convert_flow_unit(c(10, 20, 30), "L/hr", "ml/min"),
      2
    ),
    c(166.67, 333.33, 500)
  )

  expect_equal(
    round(
      convert_flow_unit(c(10, 20, 30), c("L/hr", "mL/min", "L/hr"), "ml/min"),
      2
    ),
    c(166.67, 20, 500)
  )

  expect_equal(
    round(convert_flow_unit(c(10, 20, 30), "L/hr", "ml/min"), 2),
    c(166.67, 333.33, 500)
  )

  expect_equal(
    round(
      convert_flow_unit(
        c(10, 20, 30),
        c("L/hr", "mL/min", "L/hr"),
        c("ml/min", "L/hr", "L/hr/kg"),
        weight=70
      ),
      2
    ),
    c(166.67, 1.2, 0.43)
  )

  expect_equal(
    round(
      convert_flow_unit(
        c(10, 20, 30),
        c("L/hr", "mL/min", "L/hr"),
        c("ml/min/kg", "L/hr", "L/hr/kg"),
        weight = c(70, 80, 90)
      ),
      2
    ),
    c(2.38, 1.2, 0.33)
  )
})
