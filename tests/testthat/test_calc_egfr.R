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
        method = "cockcroft_gault"
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
        relative = TRUE
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
        method = "cockcroft_gault"
      )$value
    ),
    round(
      calc_egfr(
        age = 40,
        sex="male",
        weight = 80,
        scr = 88.42,
        scr_unit = 'micromol/L',
        method = "cockcroft_gault"
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
        relative = FALSE
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
        factor = 0.3
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
        relative = FALSE
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
        relative = TRUE
      )$value
    ),
    54
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
        race="black"
      )$value
    ),
    123
  )
})


test_that("calculate egfr works: mdrd", {
  expect_equal(
    round(
      calc_egfr(
        age = 40,
        sex="male",
        weight = 80,
        height=180,
        scr = 1,
        race = "black",
        method="mdrd"
      )$value
    ),
    106
  )
})

test_that("calculate egfr works: malmo lund", {
  expect_error(
    calc_egfr(
      age = 40,
      weight = 80,
      scr = 1,
      method = "malmo_lund_revised",
      relative = FALSE
    )
  )

  expect_equal(
    round(
      calc_egfr(
        age = 40,
        sex="male",
        scr = 1,
        method = "malmo_lund_revised"
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
        relative = FALSE
      )$value
    ),
    97
  )
})

test_that("calculate egfr works: schwartz", {
  expect_error(
    calc_egfr(age = 0.5, scr = .5, weight = 4.5, method = "schwartz")
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
    relative = FALSE)
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
        method = "jelliffe"
      )$value
    ),
    76
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
        method = "wright"
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
        method = "wright"
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
        method = "cockcroft_gault"
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
    max_value = 150
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
        max_value = 150
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
    min_value = 50
  )

  expect_equal(tmp2$capped$min_value, 50)
  expect_null(tmp2$capped$max_value)
  expect_equal(tmp2$capped$min_n, 1)
})
