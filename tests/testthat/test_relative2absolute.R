test_that("convert when bsa is supplied", {
  # This is a patient with BSA < 1.7, so relative should be > absolute
  expect_equal(round(relative2absolute_bsa(59.8, 1.62)$value, 2), 56)
})

test_that("convert when height/weight supplied", {
  # This is a patient with BSA > 1.7, so relative should be < absolute
  expect_equal(
    round(relative2absolute_bsa(144.5, weight = 80, height = 200)$value), 
    180
  )
})

test_that("errors when bsa and (height or weight) missing", {
  expect_error(relative2absolute_bsa(180, height = 200))
  expect_error(relative2absolute_bsa(180, weight = 100))
})


