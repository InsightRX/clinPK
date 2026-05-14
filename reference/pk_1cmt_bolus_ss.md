# Concentration predictions for 1-compartmental PK model with bolus dosing at steady state

Concentration predictions for 1-compartmental PK model with bolus dosing
at steady state

## Usage

``` r
pk_1cmt_bolus_ss(t = c(0:24), dose = 100, tau = 12, CL = 3, V = 30, ruv = NULL)
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

  volume of distribution

- ruv:

  residual variability, specified as list with optional arguments for
  proportional, additive, or exponential components, e.g.
  `list(prop=0.1, add=1, exp=0)`

## Examples

``` r
pk_1cmt_bolus_ss(dose = 500, tau = 12, CL = 5, V = 50)
#>     t        dv
#> 1   0 14.310128
#> 2   1 12.948339
#> 3   2 11.716142
#> 4   3 10.601203
#> 5   4  9.592365
#> 6   5  8.679531
#> 7   6  7.853565
#> 8   7  7.106199
#> 9   8  6.429955
#> 10  9  5.818064
#> 11 10  5.264402
#> 12 11  4.763428
#> 13 12 14.310128
#> 14 13 12.948339
#> 15 14 11.716142
#> 16 15 10.601203
#> 17 16  9.592365
#> 18 17  8.679531
#> 19 18  7.853565
#> 20 19  7.106199
#> 21 20  6.429955
#> 22 21  5.818064
#> 23 22  5.264402
#> 24 23  4.763428
#> 25 24 14.310128
pk_1cmt_bolus_ss(
  dose = 500, tau = 12, CL = 5, V = 50,
  ruv = list(prop = 0.1, add = 0.1))
#>     t        dv
#> 1   0 15.596175
#> 2   1 12.694063
#> 3   2 11.463693
#> 4   3 10.638752
#> 5   4  9.611688
#> 6   5  9.349190
#> 7   6  6.197413
#> 8   7  9.087357
#> 9   8  6.253314
#> 10  9  5.887370
#> 11 10  5.941034
#> 12 11  4.185384
#> 13 12 15.888638
#> 14 13 12.673333
#> 15 14 10.298297
#> 16 15  9.609103
#> 17 16 10.720317
#> 18 17  8.898686
#> 19 18  8.233502
#> 20 19  5.947151
#> 21 20  5.651566
#> 22 21  5.947948
#> 23 22  6.063056
#> 24 23  5.007859
#> 25 24 16.166958
```
