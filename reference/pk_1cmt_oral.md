# Concentration predictions for 1-compartmental oral PK model after single or multiple bolus doses

Concentration predictions for 1-compartmental oral PK model after single
or multiple bolus doses

## Usage

``` r
pk_1cmt_oral(
  t = c(0:24),
  dose = 100,
  tau = 12,
  KA = 1,
  CL = 3,
  V = 30,
  F = 1,
  ruv = NULL
)
```

## Arguments

- t:

  vector of time

- dose:

  dose

- tau:

  dosing interval

- KA:

  absorption rate

- CL:

  clearance

- V:

  volume of distribution

- F:

  bioavailability, commonly between 0 an 1.

- ruv:

  residual error (list)

## References

Garrett ER. The Bateman function revisited: a critical reevaluation of
the quantitative expressions to characterize concentrations in the one
compartment body model as a function of time with first-order invasion
and first-order elimination. J Pharmacokinet Biopharm (1994)
22(2):103-128.

Bialer M. A simple method for determining whether absorption and
elimination rate constants are equal in the one-compartment open model
with first-order processes. J Pharmacokinet Biopharm (1980) 8(1):111-113

Nielsen JC, Hutmacher MM et al. J Pharmacokinet Pharmacodyn. 2012
Dec;39(6):619-34. doi: 10.1007/s10928-012-9274-0. Epub 2012 Sep 23.

https://static-content.springer.com/esm/art%3A10.1007%2Fs10928-012-9274-0/MediaObjects/10928_2012_9274_MOESM1_ESM.docx

## Examples

``` r
pk_1cmt_oral(dose = 500, tau = 12, CL = 5, V = 50, KA = 1)
#>     t        dv
#> 1   0  0.000000
#> 2   1  5.966200
#> 3   2  7.593283
#> 4   3  7.678124
#> 5   4  7.244493
#> 6   5  6.664363
#> 7   6  6.070365
#> 8   7  5.507482
#> 9   8  4.988817
#> 10  9  4.516069
#> 11 10  4.087045
#> 12 11  3.698382
#> 13 12  3.346534
#> 14 13  8.994306
#> 15 14 10.333240
#> 16 15 10.157345
#> 17 16  9.487787
#> 18 17  8.694180
#> 19 18  7.907020
#> 20 19  7.169356
#> 21 20  6.492542
#> 22 21  5.876696
#> 23 22  5.318191
#> 24 23  4.812369
#> 25 24  4.354511
```
