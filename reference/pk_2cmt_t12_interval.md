# Calculate average half-life for 2-compartment model during a specific interval

Calculate average half-life for 2-compartment model during a specific
interval

## Usage

``` r
pk_2cmt_t12_interval(CL = 3, V = 30, Q = 2, V2 = 20, tau = 12, t_inf = NULL)
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

- tau:

  interval (hours)

- t_inf:

  infusion time (hours)

## Examples

``` r
pk_2cmt_t12_interval(CL = 5, V = 50, Q = 20, V2 = 200, tau = 12, t_inf = 2)
#> [1] 10.32552
```
