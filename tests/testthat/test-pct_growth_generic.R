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
