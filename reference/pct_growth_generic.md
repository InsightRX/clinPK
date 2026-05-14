# Vectorized growth percentiles for infants and children (generic)

Internal generic function to calculate weight/height/BMI growth
percentiles for age/height for infants and children using CDC Growth
Charts data and equations.

## Usage

``` r
pct_growth_generic(
  x,
  y,
  sex,
  growth_chart,
  return_numeric = TRUE,
  return_median = FALSE,
  x_argname = "x",
  y_argname = "y",
  y_units = "raw"
)
```

## Arguments

- x:

  A numeric vector of weights/heights/BMIs.

- y:

  A numeric vector of ages/heights in the unit specified in `y_units`.

- sex:

  A character vector specifying patient sex. Either `"male"` or
  `"female"`.

- growth_chart:

  A CDC growth chart data frame (see
  [growth-charts](https://insightrx.github.io/clinPK/reference/growth-charts.md)).

- return_numeric:

  Return a numeric vector of percentiles for the given physical
  measurement? Defaults to `TRUE`. If `FALSE`, a data frame is returned
  with the observed percentile for the given physical measurement
  (`P_obs`), along with a select distribution of physical measurements
  at particular percentiles (`P01` to `P999`; the 0.1st to 99.9th
  percentiles).

- x_argname, y_argname:

  A character string for naming the `x` and `y` arguments in relevant
  output.

## Value

When `return_numeric = TRUE`, a vector of percentiles for the given
physical measurement; when `return_numeric = FALSE`, a growth chart data
frame.
