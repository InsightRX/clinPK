# Convert albumin from / to units

Accepted units are "g_l", "g_dl", or "micromol_l". Arguments supplied to
`value` and `unit_in` units must be of the same length. "To" unit must
be of length 1. \#'

## Usage

``` r
convert_albumin_unit(
  value,
  unit_in = valid_units("serum_albumin"),
  unit_out = valid_units("serum_albumin")
)
```

## Arguments

- value:

  albumin measurements

- unit_in:

  from unit, e.g. `"g_l"`.

- unit_out:

  to flow unit, e.g. `"g_dl"`

## Examples

``` r

## single values
convert_albumin_unit(0.6, "g_dl", "g_l")
#> $value
#> [1] 6
#> 
#> $unit
#> [1] "g_l"
#> 

## vectorized
convert_albumin_unit(
  c(0.4, 2, 0.3), 
  unit_in = c("g_dl", "g_l", "g_dl"),
  unit_out = c("g_l")
)
#> $value
#> [1] 4 2 3
#> 
#> $unit
#> [1] "g_l"
#> 
  
```
