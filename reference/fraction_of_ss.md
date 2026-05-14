# Calculate fraction of steady state at particular time after start of dosing

Calculate fraction of steady state at particular time after start of
dosing

## Usage

``` r
fraction_of_ss(kel = NULL, halflife = NULL, t = NULL, n = NULL, tau = NULL)
```

## Arguments

- kel:

  drug elimination rate

- halflife:

  halflife. Either `kel` or `halflife` is required.

- t:

  time at which to calculate fraction of steady state

- n:

  number of dosing intervals after which to calculate fraction of steady
  state. Requires `tau` as well, cannot be used together with `t`
  argument.

- tau:

  dosing interval

## Examples

``` r
fraction_of_ss(halflife = 24, t = 72)
#> [1] 0.875
fraction_of_ss(halflife = 36, n = 3, tau = 24)
#> [1] 0.75
```
