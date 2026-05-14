# Convert dose to expected AUCinf or AUCt for 1 compartment linear PK model

Convert dose to expected AUCinf or AUCt for 1 compartment linear PK
model

## Usage

``` r
dose2auc(dose, CL, V, t_auc = NULL)
```

## Arguments

- dose:

  dose amount

- CL:

  Clearance

- V:

  Volume of distribution

- t_auc:

  if AUC_t is desired, `t_auc` specifies time until which AUC_t is
  calculated

## Examples

``` r
dose2auc(dose = 1000, CL = 5, V = 50)
#> [1] 200
dose2auc(dose = 1000, CL = 5, V = 50, t_auc = c(12, 24, 48, 72))
#> [1] 139.7612 181.8564 198.3541 199.8507
```
