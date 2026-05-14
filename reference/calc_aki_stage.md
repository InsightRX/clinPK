# Calculate AKI stage

Calculate AKI class based on serum creatinine values over time, using
various methods for children (pRIFLE) and adults (RIFLE, kDIGO)

## Usage

``` r
calc_aki_stage(
  scr = NULL,
  times = NULL,
  method = "kdigo",
  baseline_scr = "median",
  baseline_egfr = NULL,
  first_dose_time = NULL,
  age = NULL,
  egfr = NULL,
  egfr_method = NULL,
  force_numeric = FALSE,
  override_prifle_baseline = FALSE,
  verbose = TRUE,
  return_object = TRUE,
  ...
)
```

## Arguments

- scr:

  serum creatinine in mg/dL. Use `convert_creat()` to convert from
  mmol/L. Values below the detection limit ("\<0.2") will be converted
  to numeric (0.2)

- times:

  creatinine sample times in hours

- method:

  classification method, one of `KDIGO`, `RIFLE`, `pRIFLE` (case
  insensitive)

- baseline_scr:

  baseline serum creatinine, required for `RIFLE` classifation. Will use
  value if numeric. If `character`, can be either `median`,
  `median_before_treatment`, `lowest`, or `first`.

- baseline_egfr:

  baseline eGFR, required for `RIFLE` classifations. Will take median of
  `egfr` values if `NULL`.

- first_dose_time:

  time in hours of first dose relative to sCr value, used for calculate
  baseline serum creatinine in `median_before_treatment` approach.

- age:

  age in years, needed when eGFR is used in the classification method

- egfr:

  eGFR in ml/min/1.73m^2. Optional, can also be calcualted if `age`,
  `weight`, `height`, `sex`, `egfr_method` are specified as arguments.

- egfr_method:

  eGFR calculation method, used by
  [`calc_egfr()`](https://insightrx.github.io/clinPK/reference/calc_egfr.md).
  If NULL, will pick default based on classification system
  (`cockroft_gault` for RIFLE / kDIGO, `revised_schwartz` for pRIFLE).

- force_numeric:

  keep stage numeric (1, 2, or 3), instead of e.g. "R", "I", "F" as in
  RIFLE. Default `FALSE`.

- override_prifle_baseline:

  by default, `pRIFLE` compares eGFR to 120 ml/min. Override by setting
  to TRUE.

- verbose:

  verbose (`TRUE` or `FALSE`)

- return_object:

  return object with detailed data (default `TRUE`). If `FALSE`, will
  just return maximum stage.

- ...:

  arguments passed on to
  [`calc_egfr()`](https://insightrx.github.io/clinPK/reference/calc_egfr.md)

## References

- [pRIFLE](https://pubmed.ncbi.nlm.nih.gov/17396113/): Ackan-Arikan et
  al. "Modified RIFLE criteria in critically ill children with acute
  kidney injury." Kidney Int. (2007)

- [RIFLE](https://pubmed.ncbi.nlm.nih.gov/15312219/): Bellomo et al.
  "Acute renal failure - definition, outcome measures, animal models,
  fluid therapy and information technology needs: the Second
  International Consensus Conference of the Acute Dialysis Quality
  Initiative (ADQI) Group." Critical Care. (2004)

- [KDIGO](https://pubmed.ncbi.nlm.nih.gov/22890468/): Khwaja. "KDIGO
  clinical practice guidelines for acute kidney injury." Nephron
  Clinical Practice. (2012)

- [pRIFLE baseline
  eGFR](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4238883/): Soler et
  al. "pRIFLE (Pediatric Risk, Injury, Failure, Loss, End Stage Renal
  Disease) score identifies Acute Kidney Injury and predicts mortality
  in critically ill children : a prospective study." Pediatric Critical
  Care Medicine. (2014)

## Examples

``` r
calc_aki_stage(
  scr = c(0.7, 0.9, 1.8, 1.5),
  t = c(0, 40, 100, 130),
  age = 50, weight = 60,
  height = 170, sex = "female")
#> No baseline SCr value specified, using *median* of supplied values.
#> Creatinine unit not specified, assuming mg/dL.
#> Warning: No baseline eGFR value specified, using median of supplied values.
#> Please note: Urinary output is not taken into account in staging.
#> $stage
#> [1] "stage 1"
#> 
#> $time_max_stage
#> [1] 100
#> 
#> $data
#>   scr   t deltat baseline_scr baseline_scr_diff baseline_scr_reldiff stage
#> 1 0.7   0      0          1.2              -0.5           -0.4166667    NA
#> 2 0.9  40     40          1.2              -0.3           -0.2500000    NA
#> 3 1.8 100     60          1.2               0.6            0.5000000     1
#> 4 1.5 130     30          1.2               0.3            0.2500000    NA
#>       egfr baseline_egfr_diff baseline_egfr_reldiff
#> 1 92.95488           35.11629             0.6071429
#> 2 72.29824           14.45965             0.2500000
#> 3 36.14912          -21.68947            -0.3750000
#> 4 43.37894          -14.45965            -0.2500000
#> 
#> $method
#> [1] "kdigo"
#> 
```
