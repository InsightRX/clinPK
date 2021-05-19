test_that("PK 1cmt iv steady state by summation", {
  expect_equal(
    round(
      tail(
        pk_1cmt_inf(
          dose = 100,
          tau = 12,
          t_inf = 2,
          CL = 5,
          V = 50,
          t=seq(from=0, to=10*12, by=.2)
        )$dv,
        1
      ),
      3
    ),
    0.954
  )
})
