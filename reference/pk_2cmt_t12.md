# Calculate half-life(s) for 2-compartment model

Calculate half-life(s) for 2-compartment model

## Usage

``` r
pk_2cmt_t12(CL = 3, V = 30, Q = 2, V2 = 20, phase = c("both", "alpha", "beta"))
```

## Arguments

- CL:

  clearance

- V:

  volume of central compartment

- Q:

  inter-compartimental clearance

- V2:

  volume of peripheral compartment

- phase:

  `alpha`, `beta` (default) or `both` to indicate initial (distribution)
  or terminal (elimination) phase.

## Examples

``` r
pk_2cmt_t12(CL = 5, V = 50, Q = 20, V2 = 200)
#> $alpha
#> [1] 1.189253
#> 
#> $beta
#> [1] 40.39958
#> 
```
