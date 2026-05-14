# Cmin (trough) for 2-compartmental PK model, bolus dosing at steady state

Cmin (trough) for 2-compartmental PK model, bolus dosing at steady state

## Usage

``` r
pk_2cmt_inf_cmin_ss(
  dose = 100,
  tau = 12,
  t_inf = 1,
  CL = 3,
  V = 30,
  Q = 2,
  V2 = 20,
  ruv = NULL
)
```

## Arguments

- dose:

  dose

- tau:

  dosing interval

- t_inf:

  infusion time

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
pk_2cmt_inf_cmin_ss(
  dose = 1000, tau = 12, t_inf = 2,
  CL = 5, V = 50, Q = 20, V2 = 200)
#> [1] 13.06368
```
