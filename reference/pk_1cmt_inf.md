# Concentration predictions for 1-compartmental PK model after single or multiple bolus doses

Concentration predictions for 1-compartmental PK model after single or
multiple bolus doses

## Usage

``` r
pk_1cmt_inf(
  t = c(0:24),
  dose = 100,
  tau = 12,
  t_inf = 2,
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

- tau:

  dosing interval

- t_inf:

  infusion time

- CL:

  clearance

- V:

  volume of distribution

- ruv:

  residual error (list)

## Examples

``` r
pk_1cmt_inf(dose = 500, tau = 12, t_inf = 2, CL = 5, V = 50)
#>     t        dv
#> 1   0  0.000000
#> 2   1  4.758129
#> 3   2  9.063462
#> 4   3  8.200960
#> 5   4  7.420535
#> 6   5  6.714378
#> 7   6  6.075420
#> 8   7  5.497268
#> 9   8  4.974134
#> 10  9  4.500782
#> 11 10  4.072476
#> 12 11  3.684929
#> 13 12  3.334261
#> 14 13  7.775094
#> 15 14 11.793325
#> 16 15 10.671042
#> 17 16  9.655558
#> 18 17  8.736710
#> 19 18  7.905302
#> 20 19  7.153013
#> 21 20  6.472314
#> 22 21  5.856392
#> 23 22  5.299082
#> 24 23  4.794808
#> 25 24  4.338522
pk_1cmt_inf(
  dose = 500, tau = 12, t_inf = 2, CL = 5, V = 50,
  ruv = list(prop = 0.1, add = 0.1))
#>     t           dv
#> 1   0  0.002229473
#> 2   1  4.444771202
#> 3   2  8.079427808
#> 4   3  7.495713126
#> 5   4  6.136499904
#> 6   5  6.136104832
#> 7   6  5.820701216
#> 8   7  5.210421557
#> 9   8  4.956597968
#> 10  9  4.846672246
#> 11 10  4.032843345
#> 12 11  3.083735761
#> 13 12  3.391775033
#> 14 13  7.521086583
#> 15 14 12.470623470
#> 16 15 12.924344832
#> 17 16  9.983051150
#> 18 17  7.452852509
#> 19 18  8.179105647
#> 20 19  8.018411307
#> 21 20  7.924435739
#> 22 21  6.007638408
#> 23 22  6.088076103
#> 24 23  4.848428515
#> 25 24  4.538471413
```
