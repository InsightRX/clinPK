test_that("warning if args are NULL", {
  expect_warning(convert_creat_assay(NULL))
  expect_warning({
    input <- c(0.2, 0.5)
    output <- convert_creat_assay(input, to = NULL)
  })
  expect_equal(output, input)
})

test_that("if `from` and `too` are the same, return original values", {
  expect_equal(convert_creat_assay(0.7, from = "enzym", to = "enzym"), 0.7)
  expect_equal(convert_creat_assay(0.8, from = "idms", to = "idms"), 0.8)
  expect_equal(convert_creat_assay(0.9, from = "jaffe", to = "jaffe"), 0.9)
})

test_that("enzymatic converted to jaffe by default", {
  expect_equal(convert_creat_assay(0.5, from = "enzymatic"), 0.58285714)
  expect_equal(convert_creat_assay(0.5, from = "enzym"), 0.58285714)
})

test_that("idms converted to jaffe by default", {
  expect_equal(convert_creat_assay(0.5, from = "idms"), 0.73417722)
  expect_equal(convert_creat_assay(0.5, from = "enzymatic_idms"), 0.73417722)
})

test_that("can convert jaffe to enzymatic", {
  expect_equal(
    convert_creat_assay(1.0, from = "jaffe", to = "enzymatic"),
    0.938
  )
})

test_that("can convert jaffe to idms", {
  expect_equal(
    convert_creat_assay(1.0, from = "jaffe", to = "idms"),
    0.773
  )
})

test_that("can convert idms to enzymatic", {
  orig <- 1.2
  new <- convert_creat_assay(1.2, from = "idms", to = "enzymatic")
  expect_equal(new, 1.37456280)
  # convert backwards
  expect_equal(
    convert_creat_assay(new, from = "enzymatic", to = "idms"),
    orig
  )
})

test_that("can convert enzymatic to idms", {
  orig <- 1.2
  new <- convert_creat_assay(1.2, from = "enzymatic", to = "idms")
  expect_equal(new, 1.02926095)
  # convert backwards
  expect_equal(
    convert_creat_assay(new, from = "idms", to = "enzymatic"),
    orig
  )
})

test_that("can pass vector of scr values", {
  expect_equal(
    convert_creat_assay(c(0.5, 1.2, 0.9), "idms"),
    c(0.73417722, 1.4157741, 1.12366115)
  )
})

test_that("values < 0.1 in results are set to 0.1", {
  values <- c(0.01, 0.15, 0.9) # 0.15 will be <0.1 when converted
  expect_warning({
    output <- convert_creat_assay(values, from = "jaffe", to = "idms")
  })
  expect_equal(output, c(0.1, 0.1, 0.6703))
})
