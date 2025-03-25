# pct_growth_generic() --------------------------------------------------------
test_that("missing required args throws an error", {
  # Missing `x`:
  expect_error(
    pct_growth_generic(y = 3.5, sex = "male", growth_chart = weight_for_age),
    regexp = "must all be specified"
  )
  # Missing `y`:
  expect_error(
    pct_growth_generic(x = 6, sex = "male", growth_chart = weight_for_age),
    regexp = "must all be specified"
  )
  # Missing `sex`:
  expect_error(
    pct_growth_generic(x = 6, y = 3.5, growth_chart = weight_for_age),
    regexp = "must all be specified"
  )
})

test_that("negative x values throw an error", {
  expect_error(
    pct_growth_generic(x = -6, y = 3.5, sex = "male", growth_chart = weight_for_age),
    regexp = "values must be positive"
  )
})

test_that("out of range y values throw an error", {
  expect_error(
    pct_growth_generic(x = 6, y = 241, sex = "male", growth_chart = weight_for_age),
    regexp = "values must be between"
  )
})

test_that("y values that round to the y min or max can be interpolated", {
  # y_min:
  expect_no_error(
    pct_growth_generic(
      x = 3.5,
      y = 0.1,
      sex = "male",
      growth_chart = weight_for_age
    )
  )
  # y_max:
  expect_no_error(
    pct_growth_generic(
      x = 60,
      y = 19.9,
      y_units = "years",
      sex = "male",
      growth_chart = weight_for_age
    )
  )
})

test_that("a vector is returned by default, otherwise data.frame", {
  expect_type(
    pct_growth_generic(
      x = 6,
      y = 3.5,
      sex = "male",
      growth_chart = weight_for_age
    ),
    "double"
  )
  expect_s3_class(
    pct_growth_generic(
      x = 6,
      y = 3.5,
      sex = "male",
      growth_chart = weight_for_age,
      return_numeric = FALSE
    ),
    "data.frame"
  )
})

test_that("median growth values can be returned", {
  out <- pct_growth_generic(
    x = NULL,
    y = 3.5,
    sex = "male",
    growth_chart = weight_for_age,
    return_median = TRUE
  )
  expect_equal(out, 6.391392)
})

test_that("correct percentiles are returned for `weight_for_age`", {
  out <- pct_growth_generic(
    x = weight_for_age$P50,
    y = weight_for_age$age,
    sex = ifelse(weight_for_age$sex == 1, "male", "female"),
    growth_chart = weight_for_age
  )
  expect_equal(out, rep(50, times = length(out)))
})

test_that("correct percentiles are returned for `bmi_for_age_children`", {
  out <- pct_growth_generic(
    x = bmi_for_age_children$P50,
    y = bmi_for_age_children$age,
    sex = ifelse(bmi_for_age_children$sex == 1, "male", "female"),
    growth_chart = bmi_for_age_children
  )
  # A couple values don't return exactly 50.
  expect_equal(out, rep(50, times = length(out)), tolerance = 0.1)
})

test_that("correct percentiles are returned for `weight_for_height_infants`", {
  out <- pct_growth_generic(
    x = weight_for_height_infants$P50,
    y = weight_for_height_infants$height,
    sex = ifelse(weight_for_height_infants$sex == 1, "male", "female"),
    growth_chart = weight_for_height_infants
  )
  expect_equal(out, rep(50, times = length(out)))
})

test_that("correct percentiles are returned for `weight_for_height_children`", {
  out <- pct_growth_generic(
    x = weight_for_height_children$P50,
    y = weight_for_height_children$height,
    sex = ifelse(weight_for_height_children$sex == 1, "male", "female"),
    growth_chart = weight_for_height_children
  )
  expect_equal(out, rep(50, times = length(out)))
})

test_that("unit conversion works for age", {
  out_months <- pct_growth_generic(
    x = weight_for_age$P50,
    y = weight_for_age$age,
    sex = ifelse(weight_for_age$sex == 1, "male", "female"),
    growth_chart = weight_for_age
  )
  out_years <- pct_growth_generic(
    x = weight_for_age$P50,
    y = weight_for_age$age /12,
    y_units = "years",
    sex = ifelse(weight_for_age$sex == 1, "male", "female"),
    growth_chart = weight_for_age
  )
  out_weeks <- pct_growth_generic(
    x = weight_for_age$P50,
    y = weight_for_age$age / 0.230137,
    y_units = "weeks",
    sex = ifelse(weight_for_age$sex == 1, "male", "female"),
    growth_chart = weight_for_age
  )
  out_days <- pct_growth_generic(
    x = weight_for_age$P50,
    y = weight_for_age$age / 0.0328767,
    y_units = "days",
    sex = ifelse(weight_for_age$sex == 1, "male", "female"),
    growth_chart = weight_for_age
  )
  
  expect_equal(out_months, out_years)
  expect_equal(out_months, out_weeks)
  expect_equal(out_months, out_days)
})

test_that("unit conversion works for height", {
  out_cm <- pct_growth_generic(
    x = weight_for_height_infants$P50,
    y = weight_for_height_infants$height,
    sex = ifelse(weight_for_height_infants$sex == 1, "male", "female"),
    growth_chart = weight_for_height_infants
  )
  out_m <- pct_growth_generic(
    x = weight_for_height_infants$P50,
    y = weight_for_height_infants$height / 100,
    y_units = "metres",
    sex = ifelse(weight_for_height_infants$sex == 1, "male", "female"),
    growth_chart = weight_for_height_infants
  )
  out_ft <- pct_growth_generic(
    x = weight_for_height_infants$P50,
    y = weight_for_height_infants$height / 30.48,
    y_units = "feet",
    sex = ifelse(weight_for_height_infants$sex == 1, "male", "female"),
    growth_chart = weight_for_height_infants
  )
  out_in <- pct_growth_generic(
    x = weight_for_height_infants$P50,
    y = weight_for_height_infants$height / 2.54,
    y_units = "inches",
    sex = ifelse(weight_for_height_infants$sex == 1, "male", "female"),
    growth_chart = weight_for_height_infants
  )
  
  expect_equal(out_cm, out_m)
  expect_equal(out_cm, out_ft)
  expect_equal(out_cm, out_in)
})

# pct_*_for_*_v() ---------------------------------------------------------------
test_that("pct_weight_for_age_v() works", {
  out <- pct_weight_for_age_v(
    weight = 6,
    age = 0.29,
    age_units = "years",
    sex = "male",
    return_numeric = TRUE
  )
  expect_equal(out, 31.491085)
})

test_that("pct_height_for_age_v() works", {
  out <- pct_height_for_age_v(
    height = 61,
    age = 0.29,
    age_units = "years",
    sex = "male",
    return_numeric = TRUE
  )
  expect_equal(out, 33.828905)
})

test_that("pct_bmi_for_age_v() works", {
  out <- pct_bmi_for_age_v(
    bmi = 16,
    age = 2.3,
    age_units = "years",
    sex = "male",
    return_numeric = TRUE
  )
  expect_equal(out, 37.625525)
})

test_that("pct_weight_for_height_v() works", {
  out <- pct_weight_for_height_v(
    weight = 6,
    height = 61,
    height_units = "centimetres",
    sex = "male",
    population = "infants",
    return_numeric = TRUE
  )
  expect_equal(out, 38.720054)
})

# median_*_for_*() ------------------------------------------------------------
test_that("median_weight_for_age() works", {
  out <- median_weight_for_age(
    age = 4.5,
    age_units = "months",
    sex = "male"
  )
  expect_equal(out, 7.0418364)
})

test_that("median_height_for_age() works", {
  out <- median_height_for_age(
    age = 4.5,
    age_units = "months",
    sex = "male"
  )
  expect_equal(out, 64.216864)
})

test_that("median_bmi_for_age() works", {
  out <- median_bmi_for_age(
    age = 28.5,
    age_units = "months",
    sex = "male"
  )
  expect_equal(out, 16.3433365)
})

test_that("median_weight_for_height() works", {
  out <- median_weight_for_height(
    height = 49.5,
    height_units = "centimetres",
    sex = "male",
    population = "infants"
  )
  expect_equal(out, 3.2452256)
})
