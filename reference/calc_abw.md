# Calculate adjusted body weight (ABW)

Often used for chemotherapy calculations when actual weight \> 120% of
IBW. Adjusted body weight is returned in units of kg.

## Usage

``` r
calc_abw(weight = NULL, ibw = NULL, factor = 0.4, verbose = TRUE, ...)
```

## Arguments

- weight:

  actual body weight in kg

- ibw:

  ideal body weight in kg

- factor:

  weighting factor, commonly 0.4 or 0.3

- verbose:

  show output?

- ...:

  parameters passed to ibw function (if `ibw` not specified)

## Value

adjusted body weight in kg

## Examples

``` r
calc_abw(weight = 80, ibw = 60)
#> [1] 68
calc_abw(weight = 80, height = 160, sex = "male", age = 60)
#> Note: IBW not specified, trying to calculate from other parameters.
#> [1] 66.12913
```
