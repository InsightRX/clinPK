# Convert quantity expressed relative to BSA to absolute units

Often used for eGFR estimates

## Usage

``` r
relative2absolute_bsa(quantity, bsa = NULL, ...)
```

## Arguments

- quantity:

  quantity expressed in units /1.73m2

- bsa:

  ideal body weight in kg

- ...:

  arguments passed on to `calc_bsa`, if bsa is NULL

## Value

quantity expressed in absolute units

## Examples

``` r
relative2absolute_bsa(quantity = 60, bsa = 1.6)
#> $value
#> [1] 55.49133
#> 
relative2absolute_bsa(quantity = 60, weight = 14, height = 90, method = "dubois")
#> $value
#> [1] 19.97109
#> 
```
