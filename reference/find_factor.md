# Helper function to grab the conversion factor from an input unit and given list

Helper function to grab the conversion factor from an input unit and
given list

## Usage

``` r
find_factor(full_unit, units = NULL, prefix = "^")
```

## Arguments

- full_unit:

  full unit, e.g. "mL/min/kg"

- units:

  unit specification list, e.g.
  `list("ml" = 1/1000, "dl" = 1/10, "l" = 1)`

- prefix:

  prefix used in matching units, e.g. "^" only matches at start of
  string while "\_" matches units specified as "/"
