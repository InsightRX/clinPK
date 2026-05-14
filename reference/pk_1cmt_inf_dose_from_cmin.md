# Calculate dose to achieve steady state trough for 1-compartmental PK model with infusion dosing at steady state

Calculate dose to achieve steady state trough for 1-compartmental PK
model with infusion dosing at steady state

## Usage

``` r
pk_1cmt_inf_dose_from_cmin(cmin = 1, tau = 12, t_inf = 1, CL = 3, V = 30)
```

## Arguments

- cmin:

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
dos <- pk_1cmt_inf_dose_from_cmin(
  cmin = 20, tau = 12, t_inf = 2,
  CL = 5, V = 50)
find_nearest_dose(dos, 100)
#> [1] 2100
```
