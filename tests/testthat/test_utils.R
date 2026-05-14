test_that("remove_lt_gt() removes <, >, =, space", {
  expect_equal(
    remove_lt_gt(c("<0.2", ">100", "<=1", "> 5")),
    c(0.2, 100, 1, 5)
  )
})

test_that("remove_lt_gt() preserves NAs", {
  expect_equal(
    remove_lt_gt(c("<0.2", NA)),
    c(0.2, NA)
  )
})

test_that("remove_lt_gt() returns original if couldn't convert", {
  expect_equal(
    remove_lt_gt(c("#5", "6 test", "<3", "1.5.5")),
    c("#5", "6test", "3", "1.5.5")
  )
})

test_that("remove_lt_gt() removes repeated instances of character", {
  expect_equal(remove_lt_gt("<    0.2"), 0.2)
})

test_that("remove_lt_gt() returns NULL if provided NULL", {
  expect_null(remove_lt_gt(NULL))
})

test_that("remove_lt_gt() returns original values if passed numeric vector", {
  expect_equal(remove_lt_gt(0.2), 0.2)
})

test_that("remove_lt_gt() leaves negative numbers alone", {
  expect_equal(remove_lt_gt("-<0.6"),  -0.6)
})

test_that("%>=% operator works", {
  expect_true((0.7 - 0.4) %>=% 0.3)
})

test_that("%<=% operator works", {
  expect_true((0.1 + 0.2) %<=% 0.3)
})

test_that("%>=% operator works on vectors", {
  res <- c(1, 2, 3, 4) %>=% c(0, 3, 1, 5)
  expect_equal(res, c(TRUE, FALSE, TRUE, FALSE))
})

test_that("%>=% operator handles NAs like >=", {
  expect_true(is.na(5 %>=% NA))
  expect_true(is.na(NA %>=% 6))
  res <- c(1, NA) %>=% 0
  expect_equal(res, c(TRUE, NA))
})

test_that("%>=% operator handles vectors of different lengths", {
  expect_equal(2 %>=% c(1, 3), c(TRUE, FALSE))
  expect_equal(c(1, 3) %>=% 2, c(FALSE, TRUE))
})

test_that("%>=% handles zero-length input", {
  expect_equal(c(1, 3) %>=% numeric(0), logical(0))
  expect_equal(numeric(0) %>=% 5, logical(0))
})

test_that("%<=% handles zero-length input", {
  expect_equal(c(1, 3) %<=% numeric(0), logical(0))
  expect_equal(numeric(0) %<=% 5, logical(0))
})

# check_input_lengths() -------------------------------------------------------
test_that("check_input_lengths() passes when all vectors are the same length", {
  expect_no_error(
    check_input_lengths(sex = c("male", "female"), age = c(30, 40))
  )
})

test_that("check_input_lengths() passes when some inputs are scalar", {
  expect_no_error(check_input_lengths(sex = c("male", "female"), age = 30))
})

test_that("check_input_lengths() passes when all inputs are scalar", {
  expect_no_error(check_input_lengths(sex = "male", age = 30))
})

test_that("check_input_lengths() passes when some inputs are NULL", {
  expect_no_error(
    check_input_lengths(sex = c("male", "female"), age = c(30, 40), bsa = NULL)
  )
})

test_that("check_input_lengths() errors on mismatched vector lengths", {
  expect_error(
    check_input_lengths(sex = c("male", "female"), age = c(30, 40, 50)),
    "Vector inputs must all be the same length: `sex` \\(size 2\\), `age` \\(size 3\\)\\."
  )
  # Multiple mismatches are caught too:
  expect_error(
    check_input_lengths(
      sex = c("male", "female"), age = c(30, 40, 50), scr = c(0.5, 0.6, 0.7, 0.8)
    ),
    "Vector inputs must all be the same length: `sex` \\(size 2\\), `age` \\(size 3\\), `scr` \\(size 4\\)\\."
  )
})

# normalize_sex() -------------------------------------------------------------
test_that("normalize_sex() returns lowercased sex for valid inputs", {
  expect_equal(normalize_sex("male"),   "male")
  expect_equal(normalize_sex("female"), "female")
  expect_equal(normalize_sex("Male"),   "male")
  expect_equal(normalize_sex("FEMALE"), "female")
})

test_that("normalize_sex() works on valid vectors", {
  expect_equal(normalize_sex(c("male", "female")), c("male", "female"))
  expect_equal(normalize_sex(c("Male", "Female")), c("male", "female"))
})

test_that("normalize_sex() warns and returns NULL for unsupported values", {
  expect_warning(
    res <- normalize_sex("unknown"),
    "This method requires sex to be one of 'male' or 'female'."
  )
  expect_null(res)
})

test_that("normalize_sex() warns and returns NULL for NULL input", {
  expect_warning(
    res <- normalize_sex(NULL),
    "This method requires sex to be one of 'male' or 'female'."
  )
  expect_null(res)
})

test_that("normalize_sex() warns and returns NULL if any element is unsupported", {
  expect_warning(
    res <- normalize_sex(c("male", "unknown")),
    "This method requires sex to be one of 'male' or 'female'."
  )
  expect_null(res)
})

# prepare_method_inputs() -----------------------------------------------------
test_that("prepare_method_inputs() returns inputs unchanged when all req args supplied", {
  result <- prepare_method_inputs(
    lbw_green, "green", weight = 80, sex = "male", bmi = 25
  )
  expect_equal(result$weight, 80)
  expect_equal(result$sex, "male")
  expect_equal(result$bmi, 25)
})

test_that("prepare_method_inputs() auto-computes bmi from height + weight", {
  result <- prepare_method_inputs(
    lbw_green, "green", weight = 80, sex = "male", height = 170
  )
  expect_false(is.null(result$bmi))
  expect_equal(result$bmi, calc_bmi(weight = 80, height = 170))
})

test_that("prepare_method_inputs() errors when bmi cannot be computed", {
  expect_error(
    prepare_method_inputs(lbw_green, "green", sex = "male", weight = 80),
    "Method 'green' requires: bmi or weight and height\\."
  )
})

test_that("prepare_method_inputs() errors when a required arg is missing", {
  expect_error(
    prepare_method_inputs(lbw_boer, "boer", sex = "male", height = 170),
    "Method 'boer' requires: weight\\."
  )
})

test_that("prepare_method_inputs() passes optional args through untouched", {
  result <- prepare_method_inputs(
    lbw_green, "green", weight = 80, sex = "male", bmi = 25, height = 170, age = 30
  )
  expect_equal(result$age, 30)
  expect_equal(result$height, 170)
})
