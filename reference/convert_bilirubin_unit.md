# Convert bilirubin from / to units

Accepted units are "mg_dl" and "micromol_l". Arguments supplied to
`value` and `unit_in` units must be of the same length. "To" unit must
be of length 1. \#'

## Usage

``` r
convert_bilirubin_unit(
  value,
  unit_in = valid_units("bilirubin"),
  unit_out = valid_units("bilirubin")
)
```

## Arguments

- value:

  bilirubin measurements

- unit_in:

  from unit, e.g. `"g_l"`.

- unit_out:

  to flow unit, e.g. `"g_dl"`

## Examples

``` r

## single values
convert_bilirubin_unit(1, "mg_dl", "micromol_l")
#> $value
#> [1] 17.10358
#> 
#> $unit
#> [1] "micromol_l"
#> 

## vectorized
convert_bilirubin_unit(
  c(1, 1.1, 1.2),
  unit_in = "mg_dl",
  unit_out = "micromol_l"
)
#> $value
#> [1] 17.10358 18.81394 20.52429
#> 
#> $unit
#> [1] "micromol_l"
#> 
```
