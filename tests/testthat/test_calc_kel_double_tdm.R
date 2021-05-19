# Test two-sample TDM calculation

test_that("kel correct, returned value", {
  kel1 <- calc_kel_double_tdm(
    dose = 1000,
    t = c(2, 8),
    dv = c(30, 12),
    tau = 8,
    t_inf = 1
  )
  expect_equal(kel1, (log(30/12)/6))
})

test_that("kel correct, not ss", {
  kel2 <- calc_kel_double_tdm(
    dose = 1000,
    t = c(2, 8),
    dv = c(30, 12),
    tau = 8,
    t_inf = 1,
    steady_state = FALSE,
    return_parameters = TRUE
  )
  expect_equal(kel2$kel, (log(30/12)/6))
  expect_equal(round(kel2$AUCss24, 2), 740.33)
  expect_equal(round(kel2$V, 2), 26.53)
})

test_that("kel correct, ss, V", {
  kel3 <- calc_kel_double_tdm(
    dose = 1000,
    t = c(2, 8),
    dv = c(30, 12),
    tau = 8,
    t_inf = 1,
    steady_state = TRUE,
    return_parameters = TRUE
  )
  expect_equal(round(kel3$V, 2), 37.62)
})

test_that("kel correct, ss, AUC24ss", {
  kel4 <- calc_kel_double_tdm(
    dose = 1000,
    t = c(2, 8),
    dv = c(30, 12),
    tau = 8,
    t_inf = 1,
    steady_state = TRUE,
    V = 50,
    return_parameters = TRUE
  )
  expect_equal(round(kel4$AUCss24,2), 392.89)
  expect_true(
    all(
      c("dose", "tau", "dv", "t_inf", "steady_state") %in% names(kel4$input)
    )
  )
})


test_that("correct values calculated kel for 2 samples", {
  kel2_test <- calc_kel_double_tdm(
    dose = 1000,
    t = c(2.5, 11.5),
    t_inf = 1,
    steady_state = TRUE,
    dv = c(30, 10),
    return_parameters = TRUE
  )
  expect_equal(round(kel2_test$kel, 2), 0.12)
  expect_equal(round(kel2_test$CL, 2), 4.15)
  expect_equal(round(kel2_test$V, 2), 33.98)
  expect_equal(round(kel2_test$AUCss24, 1), 482.1)
})
