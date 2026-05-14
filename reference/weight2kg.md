# Convert any weight unit to kg

Convert any weight unit to kg

## Usage

``` r
weight2kg(value = NULL, unit = NULL)
```

## Arguments

- value:

  weight in any allowed unit

- unit:

  unit of weight, one of "lb", "lbs", "pound", "pounds", "oz", "ounce",
  "ounces", "g", "gram", "grams"

## Examples

``` r
weight2kg(250, unit = "oz")
#> [1] 7.087373
weight2kg(250, unit = "pounds")
#> [1] 113.3982
weight2kg(250, unit = "lbs")
#> [1] 113.3982
```
