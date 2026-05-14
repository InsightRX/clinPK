# Calculate accumulation ratio This is the ratio of drug concentration or AUC at steady state over concentrations after single dose

Calculate accumulation ratio This is the ratio of drug concentration or
AUC at steady state over concentrations after single dose

## Usage

``` r
accumulation_ratio(kel = NULL, halflife = NULL, tau = 24)
```

## Arguments

- kel:

  drug elimination rate

- halflife:

  halflife. Either `kel` or `halflife` is required.

- tau:

  dosing interval

## Examples

``` r
accumulation_ratio(halflife = 24, tau = 24)
#> [1] 2
accumulation_ratio(kel = 0.08, tau = 12)
#> [1] 1.620464
```
