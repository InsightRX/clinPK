test_that("Unsupported methods throws error", {
  dat <- data.frame(
    time = c(0, 3, 4, 6),
    dv = c(0.001, 884, 586, 293)
  )
  expect_error( 
    nca(data = dat, dose = 5, t_inf = 2,method = "experimental_method")
  )
})

test_that("NCA estimates are correct", {
  data <- data.frame(
    time = c(0, 1, 2, 4, 6, 8),
    dv   = c(300, 1400, 1150, 900, 700, 400)
  )
  t1 <- nca(data, has_baseline = TRUE, tau = 12, t_inf = 0.5, extend = FALSE)

  expect_equal(round(t1$descriptive$auc_inf), 9216)
  expect_equal(round(t1$descriptive$auc_tau), 7991)
  expect_equal(round(t1$descriptive$auc_t), 6824)
  expect_equal(round(t1$descriptive$cav_t), 853)
  expect_equal(round(t1$descriptive$cav_tau), 666)

  t1a <- nca(data, has_baseline = TRUE, tau = 12, t_inf = 0.5, extend = TRUE)
  expect_equal(round(t1a$descriptive$auc_tau), 8296)
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
  expect_equal(round(t2$descriptive$auc_inf), 9614)
  expect_equal(round(t2$descriptive$auc_t), 7395)
  expect_equal(round(t2$descriptive$cav_t), 924)
  expect_equal(round(t2$descriptive$cav_tau), 711)
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

test_that("AUC pre-Cmax is returned and calculated appropriately", {
  # Cmax is not concentration of 1st observation (different based on extend T/F)
  dat1 <- data.frame(
    time = c(0, 2.25, 2.5, 4, 6),
    dv = c(0.001, 884, 900, 586, 293)
  )
  
  # Cmax is concentration of 1st observation (different based on extend T/F)
  dat2 <- data.frame(
    time = c(0, 2.25, 4, 6),
    dv = c(0.001, 884, 586, 293)
  )
  
  # Cmax at end of infusion (nothing to extend, should be equal)
  dat3 <- data.frame(
    time = c(0, 2, 4, 6),
    dv = c(0.001, 884, 586, 293)
  )
  
  out_extend1 <- nca(
    data = dat1,
    dose = 58000,
    tau = 6,           
    t_inf = 2,         
    scale = list(auc = 0.001, conc = 1),
    has_baseline = TRUE,
    fit_samples = NULL,
    extend = TRUE
  )[["descriptive"]][["auc_pre"]]
  out_no_extend1 <- nca(
    data = dat1,
    dose = 58000,
    tau = 6,           
    t_inf = 2,         
    scale = list(auc = 0.001, conc = 1),
    has_baseline = TRUE,
    fit_samples = NULL,
    extend = FALSE
  )[["descriptive"]][["auc_pre"]]
  out_extend2 <- nca(
    data = dat2,
    dose = 58000,
    tau = 6,           
    t_inf = 2,         
    scale = list(auc = 0.001, conc = 1),
    has_baseline = TRUE,
    fit_samples = NULL,
    extend = TRUE
  )[["descriptive"]][["auc_pre"]]
  out_no_extend2 <- nca(
    data = dat2,
    dose = 58000,
    tau = 6,           
    t_inf = 2,         
    scale = list(auc = 0.001, conc = 1),
    has_baseline = TRUE,
    fit_samples = NULL,
    extend = FALSE
  )[["descriptive"]][["auc_pre"]]
  out_extend3 <- nca(
    data = dat3,
    dose = 58000,
    tau = 6,           
    t_inf = 2,         
    scale = list(auc = 0.001, conc = 1),
    has_baseline = TRUE,
    fit_samples = NULL,
    extend = TRUE
  )[["descriptive"]][["auc_pre"]]
  out_no_extend3 <- nca(
    data = dat3,
    dose = 58000,
    tau = 6,           
    t_inf = 2,         
    scale = list(auc = 0.001, conc = 1),
    has_baseline = TRUE,
    fit_samples = NULL,
    extend = FALSE
  )[["descriptive"]][["auc_pre"]]
  expect_false(out_no_extend1 == out_extend1)
  expect_false(out_no_extend2 == out_extend2)
  expect_true(out_no_extend3 == out_extend3)
  expect_equal(round(out_no_extend1, 3), 1.125)
  expect_equal(round(out_no_extend2, 3), 0.995)
  expect_equal(round(out_no_extend3, 3), 0.884)
  expect_equal(round(out_extend2, 3), 0.884)
  expect_equal(round(out_extend1, 3), 0.9)
})

test_that("NCA with log_log method returns expected values", {
  dat <- data.frame(
    time = c(0, 3, 4, 6),
    dv = c(0.001, 884, 586, 293)
  )
  out_loglog <- nca(
    data = dat,
    dose = 58000,
    tau = 24,           
    t_inf = 2,  
    method = "log_log",
    scale = list(auc = 0.001, conc = 1),
    has_baseline = TRUE,
    fit_samples = NULL,
    extend = TRUE
  )[["descriptive"]]
  out_loglin <- nca(
    data = dat,
    dose = 58000,
    tau = 24,           
    t_inf = 2,
    method = "log_linear",
    scale = list(auc = 0.001, conc = 1),
    has_baseline = TRUE,
    fit_samples = NULL,
    extend = TRUE
  )[["descriptive"]]
  
  # exponential decay should be the same, only infusion period should vary:
  expect_equal(
    out_loglog$auc_tau - out_loglog$auc_pre,
    out_loglin$auc_tau - out_loglin$auc_pre
  )
  expect_false(out_loglog$auc_pre == out_loglin$auc_pre)
  expect_equal(round(out_loglog$auc_pre, 3), 1.427)
})

test_that("NCA with log_log method has expected arg handling", {
  dat <- data.frame(
    time = c(0, 3, 4, 6),
    dv = c(0.001, 884, 586, 293)
  )
  expect_warning( # extend needs to be TRUE for log/log
    nca(data = dat, dose = 5, t_inf = 2,method = "log_log", extend = FALSE)
  )
  expect_error( # route needs to be IV for log_log
    nca(data = dat, dose = 5, t_inf = 2,method = "log_log", route = "po")
  )
})

test_that("NCA with log_log method handles first sample after EOI not being Cmax", {
  dat <- data.frame(
    time = c(0, 3, 3.5, 4, 6),
    dv = c(0.01, 884, 925, 586, 293)
  )
  res <- nca(data = dat, dose = 5, t_inf = 2, method = "log_log")
  expect_equal(
    round(res$descriptive$auc_inf, 2), 5741.75
  )
  expect_equal(
    round(res$descriptive$auc_pre, 2), 1889.8
  )
})

test_that("linear method works", {
  res <- nca(
    data = data.frame(
      time = c(0, 1, 2, 3), 
      dv = c(0, 1, 0.5, 0.3)
    ),
    dose = 1000, 
    tau = 24, 
    t_inf = 0.5, 
    scale = list(auc = 1, conc = 1), 
    has_baseline = TRUE, 
    method = "linear", 
    fit_samples = NULL, 
    extend = FALSE
  )
  expect_equal(
    res,
    structure(list(
      pk = list(
        kel = 0.601986402162968,
        t_12 = 1.15143328498689,
        v = 639.085023502056,
        cl = 384.720493974238
      ),
      descriptive = list(
        tmax = 1,
        cav_t = 0.55,
        cav_tau = 0.20000042449491,
        c_min = 9.70274078943672e-07,
        c_max = 1.35120015480703,
        auc_inf = 4.8000117996652,
        auc_24 = 4.80001018787783,
        auc_tau = 4.80001018787783,
        auc_t = 1.65,
        auc_pre = 0.5
      ),
      settings = list(
        dose = 1000,
        interval = 24,
        last_n = 4L,
        weights = NULL
      )
    ), class = c("nca_output", "list"))
  )
})
