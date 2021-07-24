test_that("List input matches vector input", {
  res_list <- pk_2cmt_t12(
    CL = list(value = 5),
    V = list(value = 32),
    Q = list(value = 7),
    V2 = list(value = 21),
    phase = "both"
  )
  res_vec <- pk_2cmt_t12(
    CL = 5,
    V = 32,
    Q = 7,
    V2 = 21,
    phase = "both"
  )
  expect_identical(res_list, res_vec)
})

test_that("phase = 'both' returns right alpha and beta", {
  res_both <- pk_2cmt_t12(
    CL = 5,
    V = 32,
    Q = 7,
    V2 = 21,
    phase = "both"
  )
  res_alpha <- pk_2cmt_t12(
    CL = 5,
    V = 32,
    Q = 7,
    V2 = 21,
    phase = "alpha"
  )
  res_beta <- pk_2cmt_t12(
    CL = 5,
    V = 32,
    Q = 7,
    V2 = 21,
    phase = "beta"
  )
  expect_identical(res_both$alpha, res_alpha)
  expect_identical(res_both$beta, res_beta)
  expect_identical(round(res_beta, 3), 8.318)
  expect_identical(round(res_alpha, 3), 1.109)
})


