# Growth percentiles for infants and children

Calculate weight, height, and BMI growth percentiles for age/height for
infants and children using CDC Growth Charts data and equations.

## Usage

``` r
pct_weight_for_age(
  weight,
  age,
  age_units = c("years", "months", "weeks", "days"),
  sex,
  return_numeric = TRUE
)

pct_height_for_age(
  height,
  age,
  age_units = c("years", "months", "weeks", "days"),
  sex,
  return_numeric = TRUE
)

pct_bmi_for_age(
  bmi,
  age,
  age_units = c("years", "months", "weeks", "days"),
  sex,
  return_numeric = TRUE
)

pct_weight_for_height(
  weight,
  height,
  height_units = c("centimetres", "metres", "feet", "inches"),
  sex,
  population = c("infants", "children"),
  return_numeric = TRUE
)
```

## Arguments

- weight:

  A numeric vector of weights in kilograms.

- age:

  A numeric vector of ages in the unit specified in `age_units`.

- age_units:

  A character string specifying the units of all `age` values.

- sex:

  A character vector specifying patient sex. Either `"male"` or
  `"female"`.

- return_numeric:

  Return a numeric vector of percentiles for the given physical
  measurement? Defaults to `TRUE`. If `FALSE`, a data frame is returned
  with the observed percentile for the given physical measurement
  (`P_obs`), along with a select distribution of physical measurements
  at particular percentiles (`P01` to `P999`; the 0.1st to 99.9th
  percentiles).

- height:

  A numeric vector of heights in centimetres. For
  `pct_weight_for_height()`, the units should match those specified in
  `height_units`.

- bmi:

  A numeric vector of BMI in kilograms/meters squared.

- height_units:

  A character string specifying the units of all `height` values for
  `pct_weight_for_height()`.

- population:

  A character string specifying the population table to use for
  `pct_weight_for_height()`. Either `"infants"` (birth to 36 months) or
  `"children"` (2 to 20 years).

## Value

When `return_numeric = TRUE`, a vector of percentiles for the given
physical measurement; when `return_numeric = FALSE`, a growth chart data
frame.

## See also

CDC Growth Charts data:
[weight_for_age](https://insightrx.github.io/clinPK/reference/growth-charts.md),
[height_for_age](https://insightrx.github.io/clinPK/reference/growth-charts.md),
[bmi_for_age_children](https://insightrx.github.io/clinPK/reference/growth-charts.md),
[weight_for_height_infants](https://insightrx.github.io/clinPK/reference/growth-charts.md),
[weight_for_height_children](https://insightrx.github.io/clinPK/reference/growth-charts.md)

## Examples

``` r
# Returns a vector of percentiles for the given physical measurement:
pct_weight_for_age(weight = 20, age = 5, sex = "female")
#> [1] 76.53524

# Set `return_numeric = FALSE` to return a data frame with additional info:
pct_weight_for_age(
  weight = 20, age = 5, sex = "female", return_numeric = FALSE
)
#>      sex weight age         L        M         S    P_obs      P01       P1
#> 1 female     20   5 -1.284118 17.93048 0.1408402 76.53524 12.68933 13.64029
#>         P3       P5      P10      P15      P25      P50      P75      P85
#> 1 14.27484 14.63913 15.24372 15.68509 16.39324 17.93048 19.84219 21.07625
#>        P90      P95      P97      P99    P999
#> 1 22.01747 23.60511 24.78557 27.43144 33.9153

# Supply vectors of equal length to return information for each observation.
# This is particularly useful in calls to `dplyr::mutate()` or similar. 
pct_weight_for_age(
  weight = c(11, 7.2, 4.6, 4, 4.1),
  age = c(9.5, 6.1, 1.5, 2, 3),
  age_units = "months",
  sex = c("male", "female", "male", "male", "female")
)
#> [1] 90.543056 47.145711 33.764620  3.243798  1.613529
```
