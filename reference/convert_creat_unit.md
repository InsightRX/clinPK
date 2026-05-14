# Convert creatinine to different unit

Convert creatinine to different unit

## Usage

``` r
convert_creat_unit(
  value,
  unit_in = valid_units("scr"),
  unit_out = valid_units("scr")
)
```

## Arguments

- value:

  serum creatinine in either mg/dL or micromol/L

- unit_in, unit_out:

  unit, either `mg/dL` or `micromol/L`

## Examples

``` r
convert_creat_unit(1, "mg/dL", "micromol/l")
#> $value
#> [1] 88.4017
#> 
#> $unit
#> [1] "micromol/l"
#> 
convert_creat_unit(88.42, "micromol/l", "mg/dL")
#> $value
#> [1] 1.000207
#> 
#> $unit
#> [1] "mg/dl"
#> 
```
