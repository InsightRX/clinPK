# Calculate eGFR based on Cystatin C measurements

Calculate eGFR based on Cystatin C measurements

## Usage

``` r
calc_egfr_cystatin(
  cystatin = NULL,
  cystatin_unit = "mg/L",
  method = c("grubb", "larsson", "hoek"),
  unit_out = c("ml/min", "ml/hr", "l/min", "l/hr", "ml/min/1.73m2")
)
```

## Arguments

- cystatin:

  serum cystatin concentration (mg/L)

- cystatin_unit, :

  only `mg/L` available

- method:

  eGFR estimation method, choose from `grubb`, `larsson`, `hoek`

- unit_out:

  eGFR output unit, choose from `ml/min`, `ml/hr`, `l/min`, `l/hr`

## Examples

``` r
calc_egfr_cystatin(1.0)
#> $value
#> [1] 83.93
#> 
#> $unit
#> [1] "ml/min"
#> 
calc_egfr_cystatin(1.0, method = "larsson")
#> $value
#> [1] 77.239
#> 
#> $unit
#> [1] "ml/min"
#> 
calc_egfr_cystatin(1.0, unit_out = "l/hr")
#> $value
#> [1] 5.0358
#> 
#> $unit
#> [1] "l/hr"
#> 
```
