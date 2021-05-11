test_that("Errors on unknown target type", {
  expect_error(
    pk_1cmt_inf_dose_for_range(
      target = 15,
      type = "blabla",
      conc_range = c(40, 10),
      parameters = list(CL = 5, V = 50),
      interval = 8,
      t_inf = 1,
      optimize_interval = FALSE,
      round_interval = TRUE
    )
  )
})

test_that("AUC opt works", {
  dos1 <- pk_1cmt_inf_dose_for_range(
    target = 400,
    type = "auc",
    conc_range = c(40, 10),
    parameters = list(CL = 5, V = 50),
    interval = 12,
    t_inf = 1,
    optimize_interval = TRUE,
    round_interval = TRUE
  )
  expect_equal(round(dos1$dose, 1), 1000)
  expect_equal(dos1$interval, 12)
})

test_that("Cmin opt works", {
  dos2 <- pk_1cmt_inf_dose_for_range(
    target = 15,
    type = "cmin",
    conc_range = c(40, 10),
    parameters = list(CL = 5, V = 50),
    interval = 12,
    t_inf = 1,
    optimize_interval = FALSE,
    round_interval = TRUE
  )
  expect_equal(round(dos2$dose, 1), 1654.5)
  expect_equal(dos2$interval, 12)
})

test_that("Cmin opt works, shorter interval", {
  dos3 <- pk_1cmt_inf_dose_for_range(
    target = 15,
    type = "cmin",
    conc_range = c(40, 10),
    parameters = list(CL = 5, V = 50),
    interval = 8,
    t_inf = 1,
    optimize_interval = FALSE,
    round_interval = TRUE
  )
  expect_equal(round(dos3$dose, 1), 874.0)
  expect_equal(dos3$interval, 8)
})
