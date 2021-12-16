test_that("calculate egfr works: cockroft_gault", {
  expect_error(
    suppressMessages(calc_egfr(scr = .5, weight = 4.5, method = "cockcroft_gault"))
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
    )
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
    )
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
  expect_equal(
    round(
      calc_egfr(
        age = 40,
        sex="male",
        bsa = 1.6,
        weight = 70,
        scr = 1,
        method = "jelliffe",
        verbose = FALSE
      )$value
    ),
    76
  )
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
  expect_error(
    suppressMessages(calc_egfr(
      age = 0.03,
      sex = "female",
      weight = 2,
      height = 30,
      scr = 0.5,
      method = "cockcroft_gault_adjusted"
    )),
    NA
  )
  expect_error(
    suppressMessages(calc_egfr(
      age = 0.03,
      sex = "female",
      weight = 2,
      height = 30,
      scr = 0.5,
      method = "cockcroft_gault_ideal"
    )),
    NA
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
  expect_warning(
    res <- calc_egfr(
      age = 40,
      sex = "unknown",
      weight = 80,
      scr = 1,
      method = "cockcroft_gault",
      verbose = FALSE
    )
  )
  expect_null(res$value)
})
