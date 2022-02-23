test_that("NCA estimates are correct", {
  data <- data.frame(
    time = c(0, 1, 2, 4, 6, 8),
    dv   = c(300, 1400, 1150, 900, 700, 400)
  )
  t1 <- nca(data, has_baseline = TRUE, tau = 12, t_inf = 0.5, extend = FALSE)

  expect_equal(round(t1$descriptive$auc_inf), 8049)
  expect_equal(round(t1$descriptive$auc_tau), 6824)
  expect_equal(round(t1$descriptive$auc_t), 6824)
  expect_equal(round(t1$descriptive$cav_t), 853)
  expect_equal(round(t1$descriptive$cav_tau), 569)

  t1a <- nca(data, has_baseline = TRUE, tau = 12, t_inf = 0.5, extend = TRUE)
  expect_equal(round(t1a$descriptive$auc_tau), 8721)
})

test_that("NCA estimates half life different", {
  data <- data.frame(
    time = c(0, 1, 2, 4, 6, 8),
    dv   = c(300, 1400, 1150, 900, 700, 400)
  )
  t1b <- nca(
    data,
    has_baseline = TRUE,
    tau = 12,
    t_inf = 0.5,
    extend = TRUE,
    weights = function(y) { 1/sqrt(y) }
  )
  expect_equal(round(t1b$pk$t_12,2), 4.03)
})

test_that("NCA with adaptive n samples uses last 5 samples", {
  data <- data.frame(
    time = c(0, 1, 2, 4, 6, 8),
    dv   = c(300, 1400, 1150, 900, 700, 400)
  )
  t1c <- nca(data, has_baseline = TRUE, tau = 12, t_inf = 0.5, extend = TRUE )
  expect_equal(t1c$settings$last_n, 5)
})

test_that("NCA with fit_samples uses correct number of samples", {
  data <- data.frame(
    time = c(0, 1, 2, 4, 6, 8),
    dv   = c(300, 1400, 1150, 900, 700, 400)
  )
  t1d <- nca(
    data,
    has_baseline = TRUE,
    tau = 12,
    t_inf = 0.5,
    extend = TRUE,
    fit_samples = c(2:5)
  )
  expect_equal(t1d$settings$last_n, 4)
})

test_that("NCA estimates with missing data are correct", {
  data <- data.frame(
    time = c(0, 1, 2, 4, 6, 8),
    dv   = c(300, 1400, NA, 900, NA, 400)
  )
  t2 <- suppressMessages(
    nca(data, has_baseline = TRUE, tau = 12, extend = TRUE, t_inf = 0)
  )
  expect_equal(round(t2$descriptive$auc_inf), 10464)
  expect_equal(round(t2$descriptive$auc_t), 8245)
  expect_equal(round(t2$descriptive$cav_t), 1031)
  expect_equal(round(t2$descriptive$cav_tau), 782)
})

test_that("NCA with same DV at 2 different timepoints", {
  dat1 <- data.frame(time = c(0, 0.5, 1, 2.5, 4), dv = c(0, 10, 5, 5, 1))
  dat2 <- data.frame(time = c(0, 0.5, 1, 2.5, 4), dv = c(0, 10, 5.001, 5, 1))
  res1 <- nca(dat1, t_inf = 0.5)
  res2 <- nca(dat2, t_inf = 0.5)
  expect_true(
    abs(
      res1$descriptive$auc_24 - res2$descriptive$auc_24
    )/ res1$descriptive$auc_24 < 0.0001
  )
})

test_that("NCA with same DV at 3 different timepoints", {
  dat3 <- data.frame(
    time = c(0, 0.5, 1, 2.5, 4, 8),
    dv = c(0, 10, 5, 5, 5, 1)
  )
  dat4 <- data.frame(
    time = c(0, 0.5, 1, 2.5, 4, 8),
    dv = c(0, 10, 5.001, 5, 4.999, 1)
  )
  res3 <- nca(dat3, t_inf = 0.5)
  res4 <- nca(dat4, t_inf = 0.5)
  expect_true(
    abs(
      res3$descriptive$auc_24 - res4$descriptive$auc_24
    )/ res3$descriptive$auc_24 < 0.0001
  )
})

test_that("NCA with a sample at exactly tau still does peak extension", {
  dat <- data.frame(
    time = c(0, 3, 4, 6),
    dv = c(0.001, 884, 586, 293)
  )
  out_extend <- nca(
    data = dat,
    dose = 58000,
    tau = 6,           # exact time of last TDM
    t_inf = 2,         # end of infusion is an hour before first sample
    scale = list(auc = 0.001, conc = 1),
    has_baseline = TRUE,
    fit_samples = NULL,
    extend = TRUE
  )
  out_no_extend <- nca(
    data = dat,
    dose = 58000,
    tau = 6,           # exact time of last TDM
    t_inf = 2,         # end of infusion is an hour before first sample
    scale = list(auc = 0.001, conc = 1),
    has_baseline = TRUE,
    fit_samples = NULL,
    extend = FALSE
  )
  expect_true(out_no_extend$descriptive$auc_t < out_extend$descriptive$auc_t)
  expect_equal(out_extend$descriptive$auc_tau, out_extend$descriptive$auc_t)
})
