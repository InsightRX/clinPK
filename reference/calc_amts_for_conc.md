# Calculate the amounts in all compartments in a compartmental PK system based on a given concentration in the central compartment, and assuming steady state.

Calculate the amounts in all compartments in a compartmental PK system
based on a given concentration in the central compartment, and assuming
steady state.

## Usage

``` r
calc_amts_for_conc(conc = 10, parameters = NULL, n_cmt = 1)
```

## Arguments

- conc:

  concentration in central compartment

- parameters:

  for PK model

- n_cmt:

  number of compartments

## Examples

``` r
calc_amts_for_conc(conc = 10, parameters = list(CL = 5, V = 50), n_cmt = 1)
#> [1] 500
calc_amts_for_conc(
  conc = 10,
  parameters = list(CL = 5, V = 50, Q = 20, V2 = 100),
  n_cmt = 2)
#> [1]  500 1000
calc_amts_for_conc(
  conc = 10,
  parameters = list(CL = 5, V = 50, Q = 20, V2 = 100, Q2 = 30, V3 = 200),
  n_cmt = 3)
#> [1]  500 1000 2000
```
