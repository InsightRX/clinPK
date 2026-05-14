# Generic function to calculate the interval nearest to a possible dosing interval

Generic function to calculate the interval nearest to a possible dosing
interval

## Usage

``` r
find_nearest_interval(
  interval = NULL,
  possible = c(4, 6, 8, 12, 24, 36, 48),
  type = "absolute"
)
```

## Arguments

- interval:

  dose value

- possible:

  available increments of dose

- type:

  pick either `nearest` absolute interval, or nearest `lower`, or
  nearest `higher` interval.

## Examples

``` r
find_nearest_interval(19.7)
#> [1] 24
find_nearest_interval(19.7, c(6, 8, 12))
#> [1] 12
```
