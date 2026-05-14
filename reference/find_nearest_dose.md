# Generic function to calculate the dose nearest to a specific dose unit increment

Generic function to calculate the dose nearest to a specific dose unit
increment

## Usage

``` r
find_nearest_dose(dose = NULL, increment = 250, type = "round")
```

## Arguments

- dose:

  dose value

- increment:

  available increments of dose

- type:

  how to round, one of `round`, `floor`, or `ceiling`

## Examples

``` r
find_nearest_dose(573)
#> [1] 500
find_nearest_dose(573, increment = 50)
#> [1] 550
```
