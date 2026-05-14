# Calculate baseline sCr

Calculate baseline sCr

## Usage

``` r
calc_baseline_scr(
  baseline_scr,
  scr,
  times,
  method,
  first_dose_time = NULL,
  verbose
)
```

## Arguments

- baseline_scr:

  baseline serum creatinine method (character). See calc_aki_stage() for
  availabloptions.

- scr:

  serum creatinine in mg/dL. Use `convert_creat()` to convert from
  mmol/L. Values below the detection limit ("\<0.2") will be converted
  to numeric (0.2)

- times:

  creatinine sample times in hours

- method:

  classification method, one of `KDIGO`, `RIFLE`, `pRIFLE` (case
  insensitive)

- first_dose_time:

  time in hours of first dose relative to sCr value, used for calculate
  baseline serum creatinine in `median_before_treatment` approach.

- verbose:

  verbose (`TRUE` or `FALSE`)
