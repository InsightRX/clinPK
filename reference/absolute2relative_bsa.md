# Convert quantity expressed in absolute units relative to normalized BSA

Often used for eGFR estimates

## Usage

``` r
absolute2relative_bsa(quantity, bsa = NULL, ...)
```

## Arguments

- quantity:

  quantity expressed in absolute units

- bsa:

  ideal body weight in kg

- ...:

  arguments passed on to `calc_bsa`, if bsa is NULL

## Value

quantity expressed relative to /1.73m2

## Examples

``` r
absolute2relative_bsa(quantity = 60, bsa = 1.6)
#> $value
#> [1] 64.875
#> 
absolute2relative_bsa(quantity = 60, weight = 14, height = 90, method = "dubois")
#> $value
#> [1] 180.2606
#> 
```
