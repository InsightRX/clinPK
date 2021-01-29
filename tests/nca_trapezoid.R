library(clinPK)
library(testit)

## Unit tests for nca_trapezoid

dat0 <- data.frame(time = c(0.5, 1, 2, 4), dv = c(10, 8, 5, 1))
dat1 <- data.frame(time = c(0.5, 1, 2, 4), dv = c(10, 5, 5, 1))
dat2 <- data.frame(time = c(0.5, 1, 2, 4), dv = c(10, 5.001, 5, 1))
res0 <- clinPK:::nca_trapezoid(dat0)
res1 <- clinPK:::nca_trapezoid(dat1)
res2 <- clinPK:::nca_trapezoid(dat2)

## test regular case
assert("Correct AUC", round(res0,4) == 15.8350)

## test case with same DV on two different timepoints
assert("output nearly similar to case in limit", (abs(res1 - res2)/ res1) < 0.0001)

## should throw error when data is not available
assert("throws error when time=NULL", has_error(clinPK:::nca_trapezoid(data.frame(time = NULL, dv = c(10, 5)))) )
assert("throws error when dv=NULL", has_error(clinPK:::nca_trapezoid(data.frame(time = c(0, 5), dv = NULL))) )
