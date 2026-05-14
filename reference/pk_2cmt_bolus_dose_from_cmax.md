# Calculate dose to achieve steady state Cmax for 2-compartmental PK model bolus dosing at steady state

Calculate dose to achieve steady state Cmax for 2-compartmental PK model
bolus dosing at steady state

## Usage

``` r
pk_2cmt_bolus_dose_from_cmax(
  cmax = 1,
  tau = 12,
  CL = 3,
  V = 30,
  Q = 2,
  V2 = 20
)
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

- Q:

  inter-compartimental clearance

- V2:

  volume of peripheral compartment

## Examples

``` r
dos <- pk_2cmt_bolus_dose_from_cmax(
  cmax = 10, tau = 12,
  CL = 5, V = 50, Q = 20, V2 = 200)
find_nearest_dose(dos, 100)
#> [1] 300
```
