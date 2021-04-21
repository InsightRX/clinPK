library(clinPK)
library(testit)

assert(
  "remove_lt_gt() removes <, >, =, space",
  all.equal(
    clinPK:::remove_lt_gt(c("<0.2", ">100", "<=1", "> 5")),
    c(0.2, 100, 1, 5)
  )
)

assert(
  "remove_lt_gt() preserves NAs",
  all.equal(
    clinPK:::remove_lt_gt(c("<0.2", NA)),
    c(0.2, NA)
  )
)

assert(
  "remove_lt_gt() returns original if couldn't convert",
  all.equal(
    clinPK:::remove_lt_gt(c("#5", "6 test", "<3", "1.5.5")),
    c("#5", "6test", "3", "1.5.5")
  )
)

assert(
  "remove_lt_gt() removes repeated instances of character",
  clinPK:::remove_lt_gt("<    0.2") == 0.2
)

assert(
  "remove_lt_gt() returns NULL if provided NULL",
  is.null(clinPK:::remove_lt_gt(NULL))
)

assert(
  "remove_lt_gt() returns original values if passed a numeric vector",
  clinPK:::remove_lt_gt(0.2) == 0.2
)

assert(
  "remove_lt_gt() leaves negative numbers alone",
  clinPK:::remove_lt_gt("-<0.6") == -0.6
)
