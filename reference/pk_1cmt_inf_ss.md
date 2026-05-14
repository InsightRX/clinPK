# Concentration predictions for 2-compartmental PK model with infusion dosing at steady state

Concentration predictions for 2-compartmental PK model with infusion
dosing at steady state

## Usage

``` r
pk_1cmt_inf_ss(
  t = c(0:24),
  dose = 100,
  t_inf = 1,
  tau = 12,
  CL = 3,
  V = 30,
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

- ruv:

  residual variability, specified as list with optional arguments for
  proportional, additive, or exponential components, e.g.
  `list(prop=0.1, add=1, exp=0)`

## Examples

``` r
pk_1cmt_inf_ss(dose = 500, tau = 12, t_inf = 2, CL = 5, V = 50)
#>     t        dv
#> 1   0  4.771371
#> 2   1  9.075444
#> 3   2 12.969930
#> 4   3 11.735678
#> 5   4 10.618881
#> 6   5  9.608361
#> 7   6  8.694004
#> 8   7  7.866660
#> 9   8  7.118049
#> 10  9  6.440677
#> 11 10  5.827765
#> 12 11  5.273180
#> 13 12  4.771371
#> 14 13  9.075444
#> 15 14 12.969930
#> 16 15 11.735678
#> 17 16 10.618881
#> 18 17  9.608361
#> 19 18  8.694004
#> 20 19  7.866660
#> 21 20  7.118049
#> 22 21  6.440677
#> 23 22  5.827765
#> 24 23  5.273180
#> 25 24  4.771371
pk_1cmt_inf_ss(
  dose = 500, tau = 12, t_inf = 2, CL = 5, V = 50,
  ruv = list(prop = 0.1, add = 0.1))
#>     t        dv
#> 1   0  5.079726
#> 2   1  9.138869
#> 3   2 11.366403
#> 4   3 11.050248
#> 5   4 11.957736
#> 6   5 10.155337
#> 7   6  8.612823
#> 8   7  7.418775
#> 9   8  7.827875
#> 10  9  7.014191
#> 11 10  4.919766
#> 12 11  5.751224
#> 13 12  4.880352
#> 14 13  9.420388
#> 15 14 10.761815
#> 16 15 10.922987
#> 17 16  9.376038
#> 18 17  9.875445
#> 19 18  8.387565
#> 20 19  8.450272
#> 21 20  7.058097
#> 22 21  5.850960
#> 23 22  6.682154
#> 24 23  5.903988
#> 25 24  5.199365
```
