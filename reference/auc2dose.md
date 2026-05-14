# Convert AUCtau or AUCt to dose (for 1-compartment linear PK model)

Convert AUCtau or AUCt to dose (for 1-compartment linear PK model)

## Usage

``` r
auc2dose(auc, CL, V, t_auc = NA)
```

## Arguments

- auc:

  AUCtau

- CL:

  Clearance

- V:

  Volume of distribution

- t_auc:

  if AUCtau is not known but only AUCt, `t_auc` specifies time until
  which AUC_t is calculated to be able to calculate dose

## Examples

``` r
auc2dose(450, CL = 5, V = 50)
#> [1] 2250
```
