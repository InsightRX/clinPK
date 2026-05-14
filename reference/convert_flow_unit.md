# Convert flow (e.g. clearance) from / to units

Flow units are expected to be specified as a combination of volume per
time units, potentially specified per kg body weight, e.g. "mL/min", or
"L/hr/kg".

## Usage

``` r
convert_flow_unit(value = NULL, from = "l", to = "ml", weight = NULL)
```

## Arguments

- value:

  flow value

- from:

  from flow unit, e.g. `L/hr`.

- to:

  to flow unit, e.g. `mL/min`

- weight:

  for performing per weight (kg) conversion

## Details

Accepted volume units are "L", "dL", and "mL". Accepted time units are
"min", "hr", and "day". The only accepted weight unit is "kg".

The function is not case-sensitive.

## Examples

``` r

## single values
convert_flow_unit(60, "L/hr", "ml/min")
#> [1] 1000
convert_flow_unit(1, "L/hr/kg", "ml/min", weight = 80)
#> [1] 1333.333

## vectorized
convert_flow_unit(
  c(10, 20, 30), 
  from = c("L/hr", "mL/min", "L/hr"), 
  to = c("ml/min/kg", "L/hr", "L/hr/kg"), 
  weight = c(70, 80, 90))
#> [1] 2.3809524 1.2000000 0.3333333
  
```
