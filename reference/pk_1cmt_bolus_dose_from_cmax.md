# Calculate dose to achieve steady state Cmax for 1-compartmental PK model bolus dosing at steady state

Calculate dose to achieve steady state Cmax for 1-compartmental PK model
bolus dosing at steady state

## Usage

``` r
pk_1cmt_bolus_dose_from_cmax(cmax = 1, tau = 12, CL = 3, V = 30)
```

## Arguments

- cmax:

  desired trough concentration

- tau:

  dosing interval

- CL:

  clearance

- V:

  volume of distribution

## Examples

``` r
dos <- pk_1cmt_bolus_dose_from_cmax(
  cmax = 10, tau = 12, CL = 5, V = 50)
find_nearest_dose(dos, 100)
#> [1] 300
```
