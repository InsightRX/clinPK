test_that("calculate egfr works: cockroft_gault", {
  expect_error(
    suppressMessages(calc_egfr(scr = .5, weight = 4.5, method = "cockcroft_gault")),
    "Sorry, missing covariates:"
  )

  expect_equal(
    round(
      calc_egfr(
        age = 40,
        sex="male",
        weight = 80,
        scr = 1,
        method = "cockcroft_gault",
        verbose = FALSE
      )$value
    ),
    111
  )

  expect_equal(
    round(
      calc_egfr(
        age = 40,
        sex="male",
        weight = 80,
        height=180,
        scr = 1,
        method = "cockcroft_gault",
        relative = TRUE,
        verbose = FALSE
      )$value
    ),
    96
  )

  # unit converstion
  expect_equal(
    round(
      calc_egfr(
        age = 40,
        sex="male",
        weight = 80,
        scr = 1,
        scr_unit = 'mg/dl',
        method = "cockcroft_gault",
        verbose = FALSE
      )$value
    ),
    round(
      calc_egfr(
        age = 40,
        sex="male",
        weight = 80,
        scr = 88.42,
        scr_unit = 'micromol/L',
        method = "cockcroft_gault",
        verbose = FALSE
      )$value
    )
  )

  # ibw
  expect_equal(
    round(
      calc_egfr(
        age = 50,
        sex="male",
        weight = 150,
        height = 180,
        scr = 1,
        method = "cockcroft_gault_adjusted",
        relative = FALSE,
        verbose = FALSE
      )$value
    ),
    131
  )

  # abw
  expect_equal(
    round(
      calc_egfr(
        age = 40,
        sex="male",
        weight = 150,
        height = 180,
        scr = 1,
        method = "cockcroft_gault_adjusted",
        relative = FALSE,
        factor = 0.3,
        verbose = FALSE
      )$value
    ),
    135
  )
  expect_equal(
    round(
      calc_egfr(
        age = 40,
        sex="male",
        weight = 150,
        height = 180,
        scr = 1,
        method = "cockcroft_gault_ideal",
        relative = FALSE,
        verbose = FALSE
      )$value
    ),
    104
  )

  # SCI
  expect_equal(
    round(
      calc_egfr(
        age = 40,
        sex="male",
        weight = 80,
        height=180,
        scr = 1,
        method = "cockcroft_gault_sci",
        relative = TRUE,
        verbose = FALSE
      )$value
    ),
    67
  )
})

test_that("calculate egfr works: ckd-epi", {
  expect_equal(
    round(
      calc_egfr(
        age = 40,
        sex="male",
        weight = 80,
        scr = 1,
        method = "ckd-epi",
        race="black",
        verbose = FALSE
      )$value
    ),
    109
  )
})

test_that("calculate egfr works: ckd_epi_as_2021", {
  expect_equal(
    round(
      calc_egfr(
        age = 80,
        sex="female",
        weight = 83,
        scr = 0.8,
        method = "ckd_epi_as_2021",
        race="black",
        verbose = FALSE
      )$value
    ),
    74
  )
  expect_equal(
    round(
      calc_egfr(
        age = 80,
        sex="male",
        weight = 83,
        scr = 0.8,
        method = "ckd_epi_as_2021",
        race="black",
        verbose = FALSE
      )$value
    ),
    89
  )
})


test_that("calculate egfr works: mdrd, mdrd_original", {
  expect_equal(
    round(
      calc_egfr(
        age = 40,
        sex="male",
        weight = 80,
        height=180,
        scr = 1,
        race = "black",
        method="mdrd",
        verbose = FALSE
      )$value
    ),
    100
  )
  expect_equal(
    round(
      calc_egfr(
        age = 40,
        sex="male",
        weight = 80,
        height=180,
        scr = 1,
        race = "black",
        method="mdrd_original",
        verbose = FALSE
      )$value
    ),
    107
  )
})

test_that("calculate egfr works: malmo lund", {
  expect_error(
    calc_egfr(
      age = 40,
      weight = 80,
      scr = 1,
      method = "malmo_lund_revised",
      relative = FALSE,
      verbose = FALSE
    ),
    "Sorry, missing covariates:"
  )

  expect_equal(
    round(
      calc_egfr(
        age = 40,
        sex="male",
        scr = 1,
        method = "malmo_lund_revised",
        verbose = FALSE
      )$value
    ),
    84
  )
  expect_equal(
    round(
      calc_egfr(
        age = 40,
        sex="male",
        scr = 1,
        weight = 80,
        height = 180,
        method = "malmo_lund_revised",
        relative = FALSE,
        verbose = FALSE
      )$value
    ),
    97
  )
})

test_that("calculate egfr works: schwartz", {
  expect_error(
    calc_egfr(
      age = 0.5,
      scr = .5,
      weight = 4.5,
      method = "schwartz",
      verbose = FALSE
    ),
    "Sorry, missing covariates:"
  )

  expect_equal(
    calc_egfr(
      age = 0.5,
      sex="male",
      scr = .5,
      weight = 4.5,
      height = 50,
      method = "schwartz_revised",
      scr_assay="idms",
      relative = TRUE,
      verbose = FALSE
    )$value,
    41.3
  )

  expect_equal(
    calc_egfr(
      age = 0.5,
      sex = "male",
      scr = .5,
      height = 50,
      method = "schwartz_revised",
      verbose = FALSE
    )$value,
    41.3
  )

  expect_equal(
    calc_egfr(
      age = 0.5,
      sex = "male",
      scr = .5,
      weight = 4.5,
      height = 50,
      method = "schwartz",
      verbose = FALSE
    )$value,
    45
  )
})

test_that("multiple calculations work", {
  l <- calc_egfr(
    method = "malmo_lund_revised",
    weight = 45,
    age = 62,
    height = 156,
    scr = c(63, 54, 60, 52),
    scr_unit = rep("umol/l", 4),
    sex = "female",
    relative = FALSE,
    verbose = FALSE
  )
  expect_equal(
    round(l$value),
    c(65,73, 67,74)
  )
})

test_that("calculate egfr works: jelliffe", {
  egfr_relative <- calc_egfr(
    age = 40,
    sex = "male",
    bsa = 1.6,
    weight = 70,
    scr = 1,
    method = "jelliffe",
    verbose = FALSE
  )
  expect_equal(egfr_relative$value, 82)
  expect_equal(egfr_relative$unit, "ml/min/1.73m^2")

  egfr_absolute <- calc_egfr(
    age = 40,
    sex = "male",
    bsa = 1.6,
    weight = 70,
    scr = 1,
    method = "jelliffe",
    relative = FALSE,
    verbose = FALSE
  )
  expect_equal(round(egfr_absolute$value), 76)
  expect_equal(egfr_absolute$unit, "ml/min")

  # Examples from the original publication (Jelliffe, 1973)
  egfr <- function(age, sex, scr) {
    calc_egfr(
      age = age,
      sex = sex,
      scr = scr,
      scr_unit = "mg/dL",
      method = "jelliffe",
      verbose = FALSE
    )$value
  }
  expect_equal(egfr(20, "male", 1), 98)
  expect_equal(egfr(20, "female", 1), 98 * 0.9)
  expect_equal(egfr(80, "female", 1), 45)
})

test_that("calculate egfr works: jelliffe unstable", {
  # The following tests match the equation against examples in the
  # original publication. Please verify the original publication before
  # adjusting test expectations.
  
  # Examples from Table 1
  expect_equal(
    round(
      calc_egfr(
        age = 50,
        sex= "male",
        bsa = 1.73,
        weight = 72,
        scr = c(0.6, 0.6),
        times = c(1, 2),
        method = "jelliffe_unstable",
        verbose = FALSE
      )$value
    ),
    c(154, 154)
  )
  expect_equal(
    round(
      calc_egfr(
        age = 20,
        sex= "male",
        bsa = 1.73,
        weight = 72,
        scr = c(1, 1),
        times = c(1, 2),
        method = "jelliffe_unstable",
        verbose = FALSE
      )$value
    ),
    c(120, 120)
  )
  expect_equal(
    round(
      calc_egfr(
        age = 80,
        sex= "female",
        bsa = 1.73,
        weight = 72,
        scr = c(3, 3),
        times = c(1, 2),
        method = "jelliffe_unstable",
        verbose = FALSE
      )$value,
      1
    ),
    c(17.4, 17.4)
  )
  
  # Examples from Table 2
  expect_equal(
    round(
      calc_egfr(
        age = 50,
        sex = "male",
        bsa = 1.73,
        weight = 72,
        scr = c(1, 0.6),
        times = c(1, 2),
        method = "jelliffe_unstable",
        verbose = FALSE
      )$value
    ),
    c(91, 125) # actually 124 in paper, but I think it's a rounding issue
  )
  expect_equal(
    round(
      calc_egfr(
        age = 50,
        sex = "male",
        bsa = 1.73,
        weight = 72,
        scr = c(1, 3),
        times = c(1, 2),
        method = "jelliffe_unstable",
        verbose = FALSE
      )$value
    ),
    c(91, 24)
  )
  expect_equal(
    round(
      calc_egfr(
        age = 50,
        sex = "male",
        bsa = 1.73,
        weight = 72,
        scr = c(0.6, 3),
        times = c(1, 2),
        method = "jelliffe_unstable",
        verbose = FALSE
      )$value
    ),
    c(154, 23)
  )
  expect_equal(
    round(
      calc_egfr(
        age = 50,
        sex = "male",
        bsa = 1.73,
        weight = 72,
        scr = c(3, 1),
        times = c(1, 2),
        method = "jelliffe_unstable",
        verbose = FALSE
      )$value
    ),
    c(28, 64)
  )
})

test_that("calculate egfr works: wright", {
  expect_equal(
    round(
      calc_egfr(
        age = 40,
        sex="male",
        weight = 80,
        height=170,
        scr = c(.5, 1, 1.5),
        method = "wright",
        verbose = FALSE
      )$value
    ),
    c(218, 109, 73)
  )

  expect_equal(
    round(
      calc_egfr(
        age = 20,
        sex="female",
        weight = 60,
        height=150,
        scr = c(.5, 1, 1.5),
        method = "wright",
        verbose = FALSE
      )$value
    ),
    c(169, 85, 56)
  )
})

## Test cap
test_that("eGFR > upper cap", {
  expect_equal(
    round(
      calc_egfr(
        age = 40,
        sex="male",
        weight = 80,
        scr = .2,
        method = "cockcroft_gault",
        verbose = FALSE
      )$value
    ),
    556
  )
})

test_that("egfr cap applied and info added", {
  tmp1 <- calc_egfr(
    age = 40,
    sex="male",
    weight = 80,
    scr = .2,
    method = "cockcroft_gault",
    max_value = 150,
    verbose = FALSE
  )
  expect_equal(tmp1$value, 150)
  expect_equal(tmp1$capped$max_value, 150)
  expect_equal(tmp1$capped$max_n, 1)

  expect_equal(
    round(
      calc_egfr(
        age = 40,
        sex = "male",
        weight = 80,
        scr = 3,
        method = "cockcroft_gault",
        max_value = 150,
        verbose = FALSE
      )$value
    ),
    37
  )

  tmp2 <-calc_egfr(
    age = 40,
    sex = "male",
    weight = 80,
    scr = 3,
    method = "cockcroft_gault",
    min_value = 50,
    verbose = FALSE
  )

  expect_equal(tmp2$capped$min_value, 50)
  expect_null(tmp2$capped$max_value)
  expect_equal(tmp2$capped$min_n, 1)
})

test_that("calc_egfr does not error for patients < 1yr when calculating ibw", {
  expect_no_error(
    suppressMessages(calc_egfr(
      age = 0.03,
      sex = "female",
      weight = 2,
      height = 30,
      scr = 0.5,
      method = "cockcroft_gault_adjusted"
    ))
  )
  expect_no_error(
    suppressMessages(calc_egfr(
      age = 0.03,
      sex = "female",
      weight = 2,
      height = 30,
      scr = 0.5,
      method = "cockcroft_gault_ideal"
    ))
  )
})

test_that("eGFR for ckd_epi_ignore_race", {
  expect_equal(
    round(
      calc_egfr(
        age = 40,
        sex = "male",
        weight = 80,
        scr = 0.5,
        method = "ckd_epi_ignore_race",
        verbose = FALSE
      )$value
    ),
    136
  )
  expect_equal(
    calc_egfr(
      age = 40,
      sex = "male",
      race = "other",
      weight = 80,
      scr = 0.5,
      method = "ckd_epi_ignore_race",
      verbose = FALSE
    )$value,
    calc_egfr(
      age = 40,
      sex = "male",
      race = "black",
      weight = 80,
      scr = 0.5,
      method = "ckd_epi_ignore_race",
      verbose = FALSE
    )$value
  )
})

test_that("eGFR for mdrd_ignore_race and mdrd_original_ignore_race", {
  expect_equal(
    round(
      calc_egfr(
        age = 40,
        sex = "male",
        weight = 80,
        scr = 0.5,
        method = "mdrd_ignore_race",
        verbose = FALSE
      )$value
    ),
    184
  )
  expect_equal(
    round(
      calc_egfr(
        age = 40,
        sex = "male",
        weight = 80,
        scr = 0.5,
        method = "mdrd_original_ignore_race",
        verbose = FALSE
      )$value
    ),
    196
  )
  expect_equal(
    calc_egfr(
      age = 40,
      sex = "male",
      race = "other",
      weight = 80,
      scr = 0.5,
      method = "mdrd_ignore_race",
      verbose = FALSE
    )$value,
    calc_egfr(
      age = 40,
      sex = "male",
      race = "black",
      weight = 80,
      scr = 0.5,
      method = "mdrd_ignore_race",
      verbose = FALSE
    )$value
  )
  expect_equal(
    calc_egfr(
      age = 40,
      sex = "male",
      race = "other",
      weight = 80,
      scr = 0.5,
      method = "mdrd_original_ignore_race",
      verbose = FALSE
    )$value,
    calc_egfr(
      age = 40,
      sex = "male",
      race = "black",
      weight = 80,
      scr = 0.5,
      method = "mdrd_original_ignore_race",
      verbose = FALSE
    )$value
  )
})

test_that("calc_egfr warns and returns NULL if sex isn't supported", {
  methods <- c(
    "cockcroft_gault",
    "cockcroft_gault_sci",
    "cockcroft_gault_ideal",
    "cockcroft_gault_adjusted",
    "cockcroft_gault_adaptive",
    "wright",
    "jelliffe",
    "jelliffe_unstable",
    "mdrd_ignore_race",
    "mdrd_original_ignore_race",
    "ckd_epi_ignore_race",
    "ckd_epi_as_2021",
    "malmo_lund_revised",
    "schwartz"
  )
  
  for (m in methods) {
    expect_warning(
      res <- calc_egfr(
        age = 40,
        sex = "unknown",
        weight = 80,
        height = 170,
        scr = 1,
        method = m,
        verbose = FALSE
      ),
      "This method requires sex to be one of 'male' or 'female'.",
      label = paste("method:", m)
    )
    expect_null(res$value, label = paste("method:", m))
  }
})

test_that("calc_egfr converts scr appropriately", {
  res1 <- calc_egfr(
    age = 40,
    sex = "female",
    weight = 80,
    scr = 1,
    scr_unit = "MG/DL",
    method = "cockcroft_gault",
    verbose = FALSE
  )
  res2 <- calc_egfr(
    age = 40,
    sex = "female",
    weight = 80,
    scr = 1,
    scr_unit = "mg_dl",
    method = "cockcroft_gault",
    verbose = FALSE
  )
  res3 <- calc_egfr(
    age = 40,
    sex = "female",
    weight = 80,
    scr = 1 * 10e3/113.12,
    scr_unit = "micromol_l",
    method = "cockcroft_gault",
    verbose = FALSE
  )
  expect_equal(res1$value, 94.444444)
  expect_equal(res2$value, 94.444444)
  expect_equal(res3$value, 94.444444)
})

test_that("missing scr_units handled well", {
  # with unit specified as default
  expect_res <- calc_egfr(
    age = 40,
    sex = "male",
    weight = 80,
    scr = 3,
    scr_unit = NA,
    method = "cockcroft_gault",
    verbose = FALSE,
    max_value = 150,
  )$value
  
  # with character(0)
  expect_message(
    res1 <- calc_egfr(
      age = 40,
      sex = "male",
      weight = 80,
      scr = 3,
      scr_unit = character(0),
      method = "cockcroft_gault",
      max_value = 150,
    )$value,
    "Creatinine unit not specified, assuming mg/dL."
  )
  
  # with NA
  expect_message(
    res2 <- calc_egfr(
      age = 40,
      sex = "male",
      weight = 80,
      scr = 3,
      scr_unit = NA,
      method = "cockcroft_gault",
      max_value = 150,
    )$value,
    "Creatinine unit not specified, assuming mg/dL."
  )
  
  # with NULL
  expect_message(
    res3 <- calc_egfr(
      age = 40,
      sex = "male",
      weight = 80,
      scr = 3,
      scr_unit = NULL,
      method = "cockcroft_gault",
      max_value = 150,
    )$value,
    "Creatinine unit not specified, assuming mg/dL."
  )
  
  expect_equal(res1, expect_res)
  expect_equal(res2, expect_res)
  expect_equal(res3, expect_res)
})

test_that("vectorization over different sex values works for all methods", {
  methods <- c(
    "cockcroft_gault",
    "cockcroft_gault_sci",
    "cockcroft_gault_ideal",
    "cockcroft_gault_adjusted",
    "cockcroft_gault_adaptive",
    "wright",
    "jelliffe",
    "jelliffe_unstable",
    "mdrd_ignore_race",
    "mdrd_original_ignore_race",
    "ckd_epi_ignore_race",
    "ckd_epi_as_2021",
    "malmo_lund_revised",
    "schwartz"
  )

  for (m in methods) {
    male_val <- calc_egfr(
      method = m, sex = "male", age = 30, scr = 0.5,
      weight = 80, height = 170, bsa = 1.9, unit_out = "ml/min", verbose = FALSE
    )$value
    female_val <- calc_egfr(
      method = m, sex = "female", age = 30, scr = 0.5,
      weight = 80, height = 170, bsa = 1.9, unit_out = "ml/min", verbose = FALSE
    )$value
    vec_val <- calc_egfr(
      method = m, sex = c("male", "female"), age = c(30, 30), scr = c(0.5, 0.5),
      weight = c(80, 80), height = c(170, 170), bsa = c(1.9, 1.9),
      unit_out = "ml/min", verbose = FALSE
    )$value
    expect_equal(vec_val, c(male_val, female_val), label = paste("method:", m))
  }
})

test_that("calc_egfr() errors on mismatched vector lengths", {
  expect_error(
    calc_egfr(
      method = "ckd_epi_as_2021",
      sex = c("male", "female"), # length 2
      age = c(30, 40, 50), # length 3
      scr = 0.5,
      weight = 80,
      height = 170,
      verbose = FALSE
    ),
    "Vector inputs must all be the same length: `sex` \\(size 2\\), `age` \\(size 3\\)\\."
  )
})

test_that("calculate egfr works: ekfc", {
  # Patients with SCr at the healthy median (Q) have eGFR of 107.3 until age 40
  egfr_female_at_q <- calc_egfr(
    age = 30,
    sex = "female",
    scr = 62,
    scr_unit = "umol/L",
    method = "ekfc",
    verbose = FALSE
  )
  expect_equal(egfr_female_at_q$value, 107.3, tolerance = 1e-4)

  egfr_male_at_q <- calc_egfr(
    age = 30,
    sex = "male",
    scr = 80,
    scr_unit = "umol/L",
    method = "ekfc",
    verbose = FALSE
  )
  expect_equal(egfr_male_at_q$value, 107.3, tolerance = 1e-4)

  egfr_age_60 <- calc_egfr(
    age = 60,
    sex = "female",
    scr = 62,
    scr_unit = "umol/L",
    method = "ekfc",
    verbose = FALSE
  )
  expect_equal(round(egfr_age_60$value, 1), 87.8)

  egfr_adult <- calc_egfr(
    age = 70,
    sex = "male",
    scr = 1.5,
    method = "ekfc",
    verbose = FALSE
  )
  expect_equal(round(egfr_adult$value, 1), 44.8)

  # children use age- and sex-specific Q values
  egfr_child <- calc_egfr(
    age = 10,
    sex = "male",
    scr = 0.5,
    method = "ekfc",
    verbose = FALSE
  )
  expect_equal(round(egfr_child$value, 1), 109.6)

  egfr_vector <- calc_egfr(
    age = c(70, 10),
    sex = c("male", "male"),
    scr = c(1.5, 0.5),
    method = "ekfc",
    verbose = FALSE
  )
  expect_equal(round(egfr_vector$value, 1), c(44.8, 109.6))

  expect_error(
    calc_egfr(age = 40, scr = 1, method = "ekfc", verbose = FALSE),
    "Sorry, missing covariates: sex"
  )
  expect_warning(
    calc_egfr(
      age = 1,
      sex = "male",
      scr = 0.3,
      method = "ekfc",
      scr_unit = "mg/dL"
    ),
    "not meant for patients < 2 years"
  )
})

test_that("calc_egfr resolves method names", {
  egfr <- function(...) {
    calc_egfr(
      ...,
      sex = "male",
      age = 50,
      scr = 1,
      weight = 80,
      height = 180,
      verbose = FALSE
    )$value
  }
  # defaults to Cockcroft-Gault
  expect_equal(egfr(), egfr(method = "cockcroft_gault"))

  # case, separators, and legacy typo
  expect_equal(egfr(method = "CKD-EPI"), egfr(method = "ckd_epi"))
  expect_equal(
    egfr(method = "cockroft_gault"),
    egfr(method = "cockcroft_gault")
  )

  # aliases
  for (alias in c("malmo_lund_rev", "lund_malmo_revised", "lund_malmo_rev")) {
    expect_equal(egfr(method = alias), egfr(method = "malmo_lund_revised"))
  }

  expect_error(calc_egfr(method = NULL), "egfr method unspecified")
  expect_error(calc_egfr(method = "foo"), "should be one of")
})

test_that("vectorization over race works for race-based methods", {
  for (method in c("ckd_epi", "mdrd", "mdrd_original")) {
    egfr_vector <- calc_egfr(
      method = method,
      sex = c("male", "female"),
      age = c(50, 60),
      scr = c(1, 1.2),
      race = c("black", "other"),
      verbose = FALSE
    )
    egfr_black <- calc_egfr(
      method = method,
      sex = "male",
      age = 50,
      scr = 1,
      race = "black",
      verbose = FALSE
    )
    egfr_other <- calc_egfr(
      method = method,
      sex = "female",
      age = 60,
      scr = 1.2,
      race = "other",
      verbose = FALSE
    )
    expect_equal(egfr_vector$value, c(egfr_black$value, egfr_other$value))
  }

  # race is ignored by the race-free variants
  egfr_ignore_race <- calc_egfr(
    method = "ckd_epi_ignore_race",
    sex = c("male", "male"),
    age = c(50, 50),
    scr = c(1, 1),
    race = c("black", "other"),
    verbose = FALSE
  )
  expect_equal(egfr_ignore_race$value[1], egfr_ignore_race$value[2])

  expect_error(
    calc_egfr(
      method = "ckd_epi",
      sex = c("male", "female"),
      age = c(50, 60),
      scr = c(1, 1.2),
      race = c("black", "other", "other"),
      verbose = FALSE
    ),
    "Vector inputs must all be the same length"
  )
})

test_that("vectorization over age works for bedside_schwartz", {
  egfr_vector <- calc_egfr(
    method = "bedside_schwartz",
    sex = c("male", "female"),
    age = c(5, 10),
    scr = c(0.5, 0.6),
    height = c(110, 140),
    verbose = FALSE
  )
  expect_equal(egfr_vector$value, 0.413 * c(110, 140) / c(0.5, 0.6))

  expect_warning(
    calc_egfr(
      method = "bedside_schwartz",
      sex = c("male", "female"),
      age = c(0.5, 10),
      scr = c(0.3, 0.6),
      scr_unit = "mg/dL",
      height = c(65, 140)
    ),
    "not meant for patients < 1 years of age"
  )
})

test_that("calc_egfr validates unit_out", {
  egfr <- function(unit_out) {
    calc_egfr(
      method = "ckd_epi",
      sex = "male",
      age = 50,
      scr = 1,
      unit_out = unit_out,
      verbose = FALSE
    )
  }
  expect_equal(egfr("L/MIN")$value, egfr("mL/min")$value / 1000)
  expect_equal(egfr("L/MIN")$unit, "l/min/1.73m^2")
  expect_error(egfr("banana"), "`unit_out` must be one of")
  expect_error(egfr("ml/min/1.73m2"), "`unit_out` must be one of")
})

test_that("race-free methods ignore race, including NULL", {
  egfr <- function(method, race) {
    calc_egfr(
      method = method,
      sex = "female",
      age = 62,
      scr = c(63, 54, 60, 52),
      scr_unit = "umol/l",
      weight = 45,
      height = 156,
      race = race,
      relative = FALSE,
      verbose = FALSE,
      fail = FALSE
    )$value
  }
  race_free_methods <- c(
    "ckd_epi_ignore_race",
    "mdrd_ignore_race",
    "mdrd_original_ignore_race"
  )
  for (method in race_free_methods) {
    egfr_other <- egfr(method, race = "other")
    expect_length(egfr_other, 4)
    expect_equal(egfr(method, race = NULL), egfr_other)
    expect_equal(egfr(method, race = "black"), egfr_other)
    expect_error(
      egfr(method, race = c("black", "other")),
      "Vector inputs must all be the same length"
    )
  }
})

test_that("absolute and relative eGFR are converted correctly", {
  egfr <- function(method, relative = NULL) {
    calc_egfr(
      method = method,
      sex = "male",
      age = 50,
      scr = c(1, 1),
      times = c(1, 2),
      weight = 90,
      height = 190,
      bsa = 2.2,
      relative = relative,
      verbose = FALSE
    )
  }

  # Absolute methods default to absolute eGFR
  for (method in c("cockcroft_gault", "wright", "jelliffe_unstable")) {
    egfr_default <- egfr(method)
    egfr_absolute <- egfr(method, relative = FALSE)
    egfr_relative <- egfr(method, relative = TRUE)
    expect_equal(egfr_default$unit, "ml/min", label = method)
    expect_equal(egfr_absolute$value, egfr_default$value, label = method)
    expect_equal(egfr_relative$unit, "ml/min/1.73m^2", label = method)
    expect_equal(
      egfr_relative$value,
      egfr_default$value * 1.73 / 2.2,
      label = method
    )
  }

  # Relative methods default to relative eGFR
  for (method in c("jelliffe", "ckd_epi_as_2021", "ekfc")) {
    egfr_default <- egfr(method)
    egfr_relative <- egfr(method, relative = TRUE)
    egfr_absolute <- egfr(method, relative = FALSE)
    expect_equal(egfr_default$unit, "ml/min/1.73m^2", label = method)
    expect_equal(egfr_relative$value, egfr_default$value, label = method)
    expect_equal(egfr_absolute$unit, "ml/min", label = method)
    expect_equal(
      egfr_absolute$value,
      egfr_default$value * 2.2 / 1.73,
      label = method
    )
  }
})
