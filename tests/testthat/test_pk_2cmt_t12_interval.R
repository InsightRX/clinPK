test_that("List input matches vector input", {
  res_list <- pk_2cmt_t12_interval(
    CL = list(value = 5),
    V = list(value = 32),
    Q = list(value = 7),
    V2 = list(value = 21),
    tau = 24,
    t_inf = 1
  )
  res_vec <- pk_2cmt_t12_interval(
    CL = 5,
    V = 32,
    Q = 7,
    V2 = 21,
    tau = 24,
    t_inf = 1
  )
  expect_equal(res_list, res_vec)
  expect_equal(res_vec, 6.39156431)
})

test_that("t12 doesn't go to infinity for bolus due to infinitisimal issues", {
  res_bolus <- pk_2cmt_t12_interval(
    CL = 5,
    V = 32,
    Q = 7,
    V2 = 21,
    tau = 24
  )
  expect_equal(res_bolus, 6.16696475)
})
