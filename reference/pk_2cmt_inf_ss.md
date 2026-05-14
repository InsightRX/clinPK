# Concentration predictions for 2-compartmental PK model with infusion dosing at steady state

Concentration predictions for 2-compartmental PK model with infusion
dosing at steady state

## Usage

``` r
pk_2cmt_inf_ss(
  t = c(0:24),
  dose = 100,
  t_inf = 1,
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

- t_inf:

  infusion time

- tau:

  dosing interval

- CL:

  clearance

- V:

  volume of distribution

- Q:

  inter-compartimental clearance

- V2:

  volume of peripheral compartment

- ruv:

  residual variability, specified as list with optional arguments for
  proportional, additive, or exponential components, e.g.
  `list(prop=0.1, add=1, exp=0)`

## Examples

``` r
pk_2cmt_inf_ss(
  dose = 1000, tau = 12, t_inf = 2,
  CL = 5, V = 50, Q = 20, V2 = 200)
#>     t       dv
#> 1   0 13.06368
#> 2   1 20.74923
#> 3   2 25.56261
#> 4   3 20.84315
#> 5   4 18.09645
#> 6   5 16.45306
#> 7   6 15.42753
#> 8   7 14.74879
#> 9   8 14.26547
#> 10  9 13.89304
#> 11 10 13.58425
#> 12 11 13.31272
#> 13 12 13.06368
#> 14 13 20.74923
#> 15 14 25.56261
#> 16 15 20.84315
#> 17 16 18.09645
#> 18 17 16.45306
#> 19 18 15.42753
#> 20 19 14.74879
#> 21 20 14.26547
#> 22 21 13.89304
#> 23 22 13.58425
#> 24 23 13.31272
#> 25 24 13.06368
```
