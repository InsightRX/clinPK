# Concentration predictions for 2-compartmental PK model, bolus dosing at steady state

Concentration predictions for 2-compartmental PK model, bolus dosing at
steady state

## Usage

``` r
pk_2cmt_bolus_ss(
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
pk_2cmt_bolus_ss(dose = 1000, tau = 12, CL = 5, V = 50, Q = 20, V2 = 200)
#>     t       dv
#> 1   0 32.82731
#> 2   1 25.01249
#> 3   2 20.53569
#> 4   3 17.92448
#> 5   4 16.35674
#> 6   5 15.37344
#> 7   6 14.71829
#> 8   7 14.24815
#> 9   8 13.88307
#> 10  9 13.57841
#> 11 10 13.30918
#> 12 11 13.06142
#> 13 12 32.82731
#> 14 13 25.01249
#> 15 14 20.53569
#> 16 15 17.92448
#> 17 16 16.35674
#> 18 17 15.37344
#> 19 18 14.71829
#> 20 19 14.24815
#> 21 20 13.88307
#> 22 21 13.57841
#> 23 22 13.30918
#> 24 23 13.06142
#> 25 24 32.82731
```
