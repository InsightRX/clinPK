# Cmax for linear 1-compartment PK model at steady state, bolus dosing

Takes single values for dose or model parameters, or vector of either
dose or parameters (but not both).

## Usage

``` r
pk_1cmt_bolus_cmax_ss(dose = 100, tau = 12, CL = 3, V = 30, ruv = NULL)
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

- ruv:

  residual variability, specified as list with optional arguments for
  proportional, additive, or exponential components, e.g.
  `list(prop=0.1, add=1, exp=0)`

## Examples

``` r
pk_1cmt_bolus_cmax_ss(
  dose = 500, tau = 12, CL = 5, V = 50)
#> [1] 14.31013
```
