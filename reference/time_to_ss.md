# Time to steady state In either time units or number of doses

Time to steady state In either time units or number of doses

## Usage

``` r
time_to_ss(kel = NULL, halflife = NULL, ss = 0.9, in_doses = FALSE, tau = NULL)
```

## Arguments

- kel:

  drug elimination rate

- halflife:

  halflife. Either `kel` or `halflife` is required.

- ss:

  level considered "steady state", e.g. `0.9` is 90% of true steady
  state.

- in_doses:

  return the number of doses instead of time unit? Default `FALSE`.
  Requires `tau` as well.

- tau:

  dosing interval

## Examples

``` r
time_to_ss(halflife = 12, ss = 0.9)
#> [1] 39.86314
time_to_ss(halflife = 16, ss = 0.95, in_doses = TRUE, tau = 12)
#> [1] 5.762571
```
