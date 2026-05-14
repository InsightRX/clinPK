# Cmax for linear 1-compartment PK model at steady state

Takes single values for dose or model parameters, or vector of either
dose or parameters (but not both).

## Usage

``` r
pk_1cmt_inf_cmax_ss(dose, tau, CL, V, t_inf, ruv = NULL)
```

## Arguments

- dose:

  dose

- tau:

  dosing interval

- CL:

  clearance

- V:

  volume of distrubition

- t_inf:

  infusion time

- ruv:

  residual variability, specified as list with optional arguments for
  proportional, additive, or exponential components, e.g.
  `list(prop=0.1, add=1, exp=0)`

## Examples

``` r
pk_1cmt_inf_cmax_ss(dose = 500, tau = 12, t_inf = 2, CL = 5, V = 50)
#> [1] 12.96993
```
