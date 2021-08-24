test_that("convert when bsa is supplied", {
  # This is a patient with BSA < 1.7, so relative should be > absolute
  expect_equal(round(absolute2relative_bsa(56, 1.62)$value, 2), 59.80)
})

test_that("convert when height/weight supplied", {
  # This is a patient with BSA > 1.7, so relative should be < absolute
  expect_equal(
    round(absolute2relative_bsa(180, weight = 80, height = 200)$value), 
    145
  )
})

test_that("errors when bsa and (height or weight) missing", {
  expect_error(absolute2relative_bsa(180, height = 200))
  expect_error(absolute2relative_bsa(180, weight = 100))
})


