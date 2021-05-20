test_that("Table is returned", {
  dat1 <- read_who_table(sex = "male", age = 10, type = "wfa")
  dat2 <- read_who_table(sex = "female", age = 3, type = "lhfa")
  expect_true(inherits(dat1, "data.frame"))
  expect_true(nrow(dat1) > 0)
  expect_true(inherits(dat2, "data.frame"))
  expect_true(nrow(dat2) > 0)
  expected_names <- c(
    "age",
    "L",
    "M",
    "S",
    "P01",
    "P1",
    "P3",
    "P5",
    "P10",
    "P15",
    "P25",
    "P50",
    "P75",
    "P85",
    "P90",
    "P95",
    "P97",
    "P99",
    "P999"
  )
  expect_equal(names(dat1), expected_names)
  expect_equal(names(dat2), expected_names)
})

test_that("read_who_table errors if no age provided", {
  expect_error(read_who_table(sex = "male", type = "wfa"))
})

test_that("read_who_table errors if table type not recognized", {
  expect_error(read_who_table(sex = "male", age = 10, type = "not a table"))
})
