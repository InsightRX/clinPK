test_that("pk_1cmt_bolus returns a row for each timepoint", {
  res1 <- pk_1cmt_bolus()
  res2 <- pk_1cmt_bolus(t = 0:10)
  res3 <- pk_1cmt_bolus(t = seq(0, 8, by = 2))
  expect_equal(nrow(res1), 25)
  expect_equal(res1$t, 0:24)
  expect_equal(nrow(res2), 11)
  expect_equal(res2$t, 0:10)
  expect_equal(res3$t, seq(0, 8, by = 2))
  expect_equal(res3$dv, res2[res2$t %in% seq(0, 8, by = 2), "dv"])
})

test_that("pk_1cmt_bolus returns expected values", {
  res1 <- pk_1cmt_bolus(t = 0:2)
  res2 <- pk_1cmt_bolus(t = 0:2, dose = 500)
  expect_equal(
    res1,
    data.frame(
      t = c(0, 1, 2),
      dv = c(3.33333333333333, 3.01612472678653, 2.72910251025994)
    )
  )
  expect_equal(
    res2,
    data.frame(
      t = c(0, 1, 2),
      dv = c(16.6666666666667, 15.0806236339327, 13.6455125512997)
    )
  )
  expect_true(all(res1$dv < res2$dv)) # res2 has higher dose
})

test_that("faster decline when CL is higher", {
  res1 <- pk_1cmt_bolus(t = 0:1, CL = 3)
  res2 <- pk_1cmt_bolus(t = 0:1, CL = 7)
  expect_equal(res1$dv[[1]], res2$dv[[1]])
  expect_lt(res2$dv[[2]], res1$dv[[2]])
})

test_that("lower V -> higher concentration", {
  res1 <- pk_1cmt_bolus(t = 0:1, V = 20)
  res2 <- pk_1cmt_bolus(t = 0:1, V = 50)
  expect_equal(
    res1,
    data.frame(
      t = c(0, 1),
      dv = c(5, 4.30353988212529)
    )
  )
  expect_equal(
    res2,
    data.frame(
      t = c(0, 1),
      dv = c(2, 1.8835290671685)
    )
  )
  expect_gt(res1$dv[[1]], res2$dv[[1]])
})

test_that("multiple doses show up in results of pk_1cmt_bolus", {
  res <- pk_1cmt_bolus(t = 0:12, tau = 6)
  diffs <- diff(res$dv)
  # Expect increased concentration at t = 6 and t = 12
  expect_true(all(diffs[c(6, 12)] > 0))
})

test_that("pk_1cmt_bolus adds RUV if provided", {
  set.seed(123)
  res1 <- pk_1cmt_bolus(t = 0:5)
  res2 <- pk_1cmt_bolus(t = 0:5, ruv = list(prop = 0.1, add = 0.1))
  expect_false(all(res1$dv == res2$dv))
  expect_equal(
    res2,
    data.frame(
      t = c(0, 1, 2, 3, 4, 5),
      dv = c(
        3.19259973841485,
        2.82019420156786,
        3.08580470236133,
        2.44223917228849,
        2.38569638672439,
        2.4044967477293
      )
    )
  )
})
