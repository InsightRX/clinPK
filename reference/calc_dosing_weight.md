# Calculate commonly used "dosing weight"

Dosing weight is determined based on total (TBW), ideal (IBW), or
adjusted (ABW) body weight in kg.

## Usage

``` r
calc_dosing_weight(weight, height, age, sex, verbose = TRUE, ...)
```

## Arguments

- weight:

  weight

- height:

  height

- age:

  age

- sex:

  sex

- verbose:

  verbosity (`TRUE` or `FALSE`)

- ...:

  pased to
  [`calc_abw()`](https://insightrx.github.io/clinPK/reference/calc_abw.md)
  function

## Value

Returns a list of the following elements:

- value:

  Dosing weight, in units of kg

- unit:

  Units of dosing weight (kg)

- type:

  Type of dosing weight selected, e.g., total body weight, ideal body
  weight.

## Details

This is derived using following:

- In principle, use IBW

- If total body weight (TBW) \> 1.2\*IBW, then use ABW

- If TBW \< IBW, use TBW

## Examples

``` r
calc_dosing_weight(weight = 50, height = 170, sex = "female", age = 50)
#> Using total body weight.
#> $value
#> [1] 50
#> 
#> $unit
#> [1] "kg"
#> 
#> $type
#> [1] "Total BW"
#> 
```
