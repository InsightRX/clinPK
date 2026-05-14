# Median growth values for infants and children

Calculate median weight, height, and BMI for age/height for infants and
children using CDC Growth Charts data and equations.

## Usage

``` r
median_weight_for_age(
  age,
  age_units = c("years", "months", "weeks", "days"),
  sex
)

median_height_for_age(
  age,
  age_units = c("years", "months", "weeks", "days"),
  sex
)

median_bmi_for_age(age, age_units = c("years", "months", "weeks", "days"), sex)

median_weight_for_height(
  height,
  height_units = c("centimetres", "metres", "feet", "inches"),
  sex,
  population = c("infants", "children")
)
```

## Arguments

- age:

  A numeric vector of ages in the unit specified in `age_units`.

- age_units:

  A character string specifying the units of all `age` values.

- sex:

  A character vector specifying patient sex. Either `"male"` or
  `"female"`.

- height:

  A numeric vector of heights in the unit specified in `height_units`.

- height_units:

  A character string specifying the units of all `height` values.

- population:

  A character string specifying the population table to use for
  `median_weight_for_height()`. Either "infants" (birth to 36 months) or
  "children" (2 to 20 years).

## Value

A numeric vector of median weight, height, or BMI values for the given
ages/heights.

## See also

Functions to calculate growth metrics:
[pct_weight_for_age](https://insightrx.github.io/clinPK/reference/pct_x_for_y.md),
[pct_height_for_age](https://insightrx.github.io/clinPK/reference/pct_x_for_y.md),
[pct_bmi_for_age](https://insightrx.github.io/clinPK/reference/pct_x_for_y.md),
[pct_weight_for_height](https://insightrx.github.io/clinPK/reference/pct_x_for_y.md)

CDC Growth Charts data:
[weight_for_age](https://insightrx.github.io/clinPK/reference/growth-charts.md),
[height_for_age](https://insightrx.github.io/clinPK/reference/growth-charts.md),
[bmi_for_age_children](https://insightrx.github.io/clinPK/reference/growth-charts.md),
[weight_for_height_infants](https://insightrx.github.io/clinPK/reference/growth-charts.md),
[weight_for_height_children](https://insightrx.github.io/clinPK/reference/growth-charts.md)

## Examples

``` r
median_weight_for_age(3.5, "months", sex = "male")
#> [1] 6.391392
```
