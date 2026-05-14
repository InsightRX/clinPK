# CDC Growth Charts

Data used to produce the United States Growth Charts smoothed percentile
curves for infants and older children.

## Usage

``` r
weight_for_age

height_for_age

bmi_for_age_children

weight_for_height_infants

weight_for_height_children
```

## Format

### `weight_for_age`

An object of class `data.frame` with 484 rows and 14 columns.

### `height_for_age`

An object of class `data.frame` with 484 rows and 14 columns.

### `bmi_for_age_children`

An object of class `data.frame` with 438 rows and 15 columns.

### `weight_for_height_infants`

An object of class `data.frame` with 120 rows and 14 columns.

### `weight_for_height_children`

An object of class `data.frame` with 92 rows and 15 columns.

## Source

National Center for Health Statistics. (n.d.). CDC Growth Charts Data
Files. <https://www.cdc.gov/growthcharts/cdc-growth-charts.htm>

## Details

These data sets contain the L (power in the Box-Cox transformation), M
(median), and S (generalized coefficient of variation) parameters needed
to generate exact percentiles and z-scores for seven different growth
charts, along with the 3rd, 5th, 10th, 25th, 50th, 75th, 90th, 95th, and
97th percentile values by sex (1 = male; 2 = female) and single month of
age (listed at the half-month point for the entire month).

## See also

Functions to calculate growth metrics:
[pct_weight_for_age](https://insightrx.github.io/clinPK/reference/pct_x_for_y.md),
[pct_height_for_age](https://insightrx.github.io/clinPK/reference/pct_x_for_y.md),
[pct_bmi_for_age](https://insightrx.github.io/clinPK/reference/pct_x_for_y.md),
[pct_weight_for_height](https://insightrx.github.io/clinPK/reference/pct_x_for_y.md)
