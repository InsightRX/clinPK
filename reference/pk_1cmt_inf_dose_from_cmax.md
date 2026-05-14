# Calculate dose to achieve steady state Cmax for 1-compartmental PK model with infusion dosing at steady state

Calculate dose to achieve steady state Cmax for 1-compartmental PK model
with infusion dosing at steady state

## Usage

``` r
pk_1cmt_inf_dose_from_cmax(cmax = 1, tau = 12, t_inf = 1, CL = 3, V = 30)
```

## Arguments

- cmax:

  desired trough concentration

- tau:

  dosing interval

- t_inf:

  infusion time

- CL:

  clearance

- V:

  volume of distribution

## Examples

``` r
pk_1cmt_inf_dose_from_cmax(cmax = 20, tau = 12, t_inf = 2, CL = 5, V = 50)
#> [1] 771.0142
```
