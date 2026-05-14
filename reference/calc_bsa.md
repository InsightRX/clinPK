# Calculate body surface area

Get an estimate of body-surface area (in m2) based on weight and height

## Usage

``` r
calc_bsa(
  weight = NULL,
  height = NULL,
  method = c("dubois", "mosteller", "haycock", "gehan_george", "boyd")
)
```

## Arguments

- weight:

  weight

- height:

  height

- method:

  estimation method, choose from `dubois`, `mosteller`, `haycock`,
  `gehan_george`, `boyd`

## Value

Returns a list of the following elements:

- value:

  Body Surface Area (BSA) in units of m2

- unit:

  Unit describing BSA, (m2)

## Examples

``` r
calc_bsa(weight = 70, height = 170)
#> $value
#> [1] 1.809708
#> 
#> $unit
#> [1] "m2"
#> 
calc_bsa(weight = 70, height = 170, method = "gehan_george")
#> $value
#> [1] 1.831289
#> 
#> $unit
#> [1] "m2"
#> 
```
