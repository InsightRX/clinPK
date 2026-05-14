# Concentration predictions for 2-compartmental PK model, single or multiple infusions

Concentration predictions for 2-compartmental PK model, single or
multiple infusions

## Usage

``` r
pk_2cmt_inf(
  t = c(0:24),
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

  volume of central compartment

- Q:

  inter-compartimental clearance

- V2:

  volume of peripheral compartment

- ruv:

  residual error (list)
