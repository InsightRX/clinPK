library(clinPK)
library(testit)


assert(
  "missing sex or missing age throws error", {
  has_error(
    clinPK:::pct_for_age_generic(age = 17, value = 167),
    silent = TRUE
  )
  has_error(
    clinPK:::pct_for_age_generic(sex = "female", value = 167),
    silent = TRUE
  )
})

assert(
  "Age out of bounds returns NULL", {
    is.null(
      clinPK:::pct_for_age_generic(
        age = 21, 
        sex = "female", 
        value = 167, 
        variable = "height"
      )
    )
    is.null(
      clinPK:::pct_for_age_generic(
        age = 21, 
        sex = "female", 
        value = 167, 
        variable = "weight"
      )
    )
})

assert(
  "Correct percentiles: height", {
  pct1 <- clinPK:::pct_for_age_generic(
    age = 4, 
    sex = "female", 
    value = 100, 
    variable = "height"
  )
  pct2 <- clinPK:::pct_for_age_generic(
    age = 6, 
    sex = "male", 
    value = 120, 
    variable = "height"
  )
  pct1$percentile == 26.7
  pct2$percentile == 79.1
})

assert(
  "Correct percentiles: weight", {
    pct1 <- clinPK:::pct_for_age_generic(
      age = 4, 
      sex = "female", 
      value = 15, 
      variable = "weight"
    )
    pct2 <- clinPK:::pct_for_age_generic(
      age = 6, 
      sex = "male", 
      value = 25, 
      variable = "weight"
    )
    pct1$percentile == 31.2
    pct2$percentile == 92
})

assert(
  "Correct percentiles: bmi", {
    pct1 <- clinPK:::pct_for_age_generic(
      age = 4, 
      sex = "male", 
      value = 17, 
      variable = "bmi"
    )
    pct2 <- clinPK:::pct_for_age_generic(
      age = 6, 
      sex = "female", 
      value = 17, 
      variable = "bmi"
    )
    pct1$percentile == 88.9
    pct2$percentile == 83.8
})

assert(
  "extreme percentiles capped to min and max", {
    pct1 <- clinPK:::pct_for_age_generic(
      age = 4, 
      sex = "male", 
      value = 1, 
      variable = "weight"
    )
    pct2 <- clinPK:::pct_for_age_generic(
      age = 4, 
      sex = "male", 
      value = 100, 
      variable = "weight"
    )
    pct1$percentile == 0.1
    pct2$percentile == 99.9
})
