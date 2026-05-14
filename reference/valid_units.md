# Valid units

Return recognized units for height, weight, age, scr, serum_albumin.

## Usage

``` r
valid_units(
  covariate = c("height", "weight", "age", "scr", "serum_albumin", "bilirubin")
)
```

## Arguments

- covariate:

  Covariate (one of "height", "weight", "age", "scr", "bilirubin",
  "serum_albumin")

## Value

Vector of valid units for the given covariate

## Examples

``` r
valid_units("height")
#> [1] "cm"     "inch"   "inches" "in"    
valid_units("weight")
#>  [1] "kg"     "lb"     "lbs"    "pound"  "pounds" "oz"     "ounce"  "ounces"
#>  [9] "g"      "gram"   "grams" 
```
