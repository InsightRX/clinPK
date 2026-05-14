# Concentration predictions for 1-compartmental PK model after single or multiple bolus doses

Concentration predictions for 1-compartmental PK model after single or
multiple bolus doses

## Usage

``` r
pk_1cmt_bolus(t = c(0:24), dose = 100, tau = 12, CL = 3, V = 30, ruv = NULL)
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

  residual error (list)

## Examples

``` r
pk_1cmt_bolus(dose = 500, tau = 12, CL = 5, V = 50)
#>     t        dv
#> 1   0 10.000000
#> 2   1  9.048374
#> 3   2  8.187308
#> 4   3  7.408182
#> 5   4  6.703200
#> 6   5  6.065307
#> 7   6  5.488116
#> 8   7  4.965853
#> 9   8  4.493290
#> 10  9  4.065697
#> 11 10  3.678794
#> 12 11  3.328711
#> 13 12 13.011942
#> 14 13 11.773692
#> 15 14 10.653277
#> 16 15  9.639484
#> 17 16  8.722166
#> 18 17  7.892142
#> 19 18  7.141105
#> 20 19  6.461539
#> 21 20  5.846642
#> 22 21  5.290261
#> 23 22  4.786826
#> 24 23  4.331299
#> 25 24 13.919122
pk_1cmt_bolus(dose = 500, tau = 12, CL = 5, V = 50, t = 24)
#>    t       dv
#> 1 24 13.91912
pk_1cmt_bolus(
  dose = 500, tau = 12, CL = 5, V = 50,
  ruv = list(prop = 0.1, add = 0.1))
#>     t        dv
#> 1   0  8.590212
#> 2   1  9.185810
#> 3   2  6.190250
#> 4   3  7.321376
#> 5   4  6.968600
#> 6   5  6.855390
#> 7   6  4.505930
#> 8   7  4.867403
#> 9   8  4.545919
#> 10  9  3.961961
#> 11 10  3.461700
#> 12 11  3.347072
#> 13 12 15.671017
#> 14 13  9.822071
#> 15 14 11.305911
#> 16 15  7.850640
#> 17 16  8.202945
#> 18 17  7.845631
#> 19 18  7.503716
#> 20 19  5.915386
#> 21 20  6.395897
#> 22 21  5.486925
#> 23 22  4.220135
#> 24 23  4.662672
#> 25 24 16.356583
```
