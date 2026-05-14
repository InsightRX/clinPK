# Concentration predictions for 2-compartmental PK model, single or multiple bolus doses

Concentration predictions for 2-compartmental PK model, single or
multiple bolus doses

## Usage

``` r
pk_2cmt_bolus(
  t = c(0:24),
  dose = 100,
  tau = 12,
  CL = 3,
  V = 30,
  Q = 2,
  V2 = 20,
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

- CL:

  clearance

- V:

  volume of central compartment

- Q:

  inter-compartimental clearance

- V2:

  volume of peripheral compartment

- ruv:

  residual error (list)

## Examples

``` r
pk_2cmt_bolus(dose = 1000, tau = 24, CL = 5, V = 50, Q = 15, V2 = 200)
#>     t        dv
#> 1   0 20.000000
#> 2   1 13.575304
#> 3   2  9.498884
#> 4   3  6.907144
#> 5   4  5.254168
#> 6   5  4.194858
#> 7   6  3.511060
#> 8   7  3.064867
#> 9   8  2.769100
#> 10  9  2.568645
#> 11 10  2.428660
#> 12 11  2.327114
#> 13 12  2.250079
#> 14 13  2.188748
#> 15 14  2.137547
#> 16 15  2.092953
#> 17 16  2.052732
#> 18 17  2.015472
#> 19 18  1.980275
#> 20 19  1.946572
#> 21 20  1.913997
#> 22 21  1.882320
#> 23 22  1.851390
#> 24 23  1.821108
#> 25 24 21.791411
```
