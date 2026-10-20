# Calculate eGFR based on cystatin C measurements

Calculate eGFR based on cystatin C measurements

## Usage

``` r
calc_egfr_cystatin(
  cystatin = NULL,
  cystatin_unit = "mg/L",
  method = c("grubb", "larsson", "hoek", "ekfc", "ckd_epi"),
  unit_out = NULL,
  age = NULL,
  sex = NULL,
  verbose = TRUE
)
```

## Arguments

- cystatin:

  serum cystatin concentration (mg/L)

- cystatin_unit:

  only `"mg/L"` available

- method:

  eGFR estimation method, choose from `"grubb"`, `"larsson"`, `"hoek"`,
  `"ekfc"`, `"ckd_epi"`

- unit_out:

  eGFR output unit, choose from `"ml/min"`, `"ml/hr"`, `"l/min"`,
  `"l/hr"`, `"ml/min/1.73m2"`. The Larsson method reports absolute eGFR,
  so it supports all units except `"ml/min/1.73m2"`. The other methods
  report eGFR per 1.73 m2, so they only support `"ml/min/1.73m2"`. If
  `NULL` (default), uses `"ml/min"` for the Larsson method, and
  `"ml/min/1.73m2"` for the others.

- age:

  age, in years. Required for the `"ekfc"` and `"ckd_epi"` methods.
  Optional for the `"grubb"` method, where it is only used to warn for
  patients \< 18 years of age.

- sex:

  sex, `"male"` or `"female"`. Required for the `"ckd_epi"` method.

- verbose:

  verbosity, show guidance and warnings. `TRUE` by default

## Details

The Grubb, Larsson, and Hoek equations were developed with cystatin C
assays calibrated before the introduction of the international reference
material for cystatin C (ERM-DA471/IFCC), and may be biased when used
with results from standardized assays. The EKFC and CKD-EPI equations
were developed with standardized assays.

## References

- Grubb: [Grubb et al., Clinical Chemistry
  (2005)](https://doi.org/10.1373/clinchem.2005.051557). Uses the
  equation derived for adults (\>= 18 years), without adjustment for
  sex. Cystatin C measured with DakoCytomation reagents.

- Larsson: [Larsson et al., Scandinavian Journal of Clinical and
  Laboratory Investigation
  (2004)](https://doi.org/10.1080/00365510410003723). Uses the equation
  for the Dade Behring cystatin C calibration.

- Hoek: [Hoek et al., Nephrology Dialysis Transplantation
  (2003)](https://doi.org/10.1093/ndt/gfg349). Cystatin C measured with
  the Dade Behring N Latex assay.

- EKFC: [Pottel et al., NEJM
  (2023)](https://www.nejm.org/doi/full/10.1056/NEJMoa2203769).
  Validated in adults (\>= 18 years) only.

- CKD-EPI (2012): [Inker et al., NEJM
  (2012)](https://www.nejm.org/doi/full/10.1056/NEJMoa1114248).
  Developed in adults (\>= 18 years) only.

## See also

- [`calc_egfr()`](https://insightrx.github.io/clinPK/reference/calc_egfr.md)
  for equations using creatinine alone

- [`calc_egfr_combined()`](https://insightrx.github.io/clinPK/reference/calc_egfr_combined.md)
  for equations using both creatinine and cystatin C

## Examples

``` r
calc_egfr_cystatin(1.0)
#> $value
#> [1] 83.93
#> 
#> $unit
#> [1] "ml/min/1.73m2"
#> 
calc_egfr_cystatin(1.0, method = "larsson")
#> $value
#> [1] 77.239
#> 
#> $unit
#> [1] "ml/min"
#> 
calc_egfr_cystatin(1.0, method = "larsson", unit_out = "l/hr")
#> $value
#> [1] 4.63434
#> 
#> $unit
#> [1] "l/hr"
#> 
calc_egfr_cystatin(1.0, method = "ekfc", age = 50)
#> $value
#> [1] 78.58652
#> 
#> $unit
#> [1] "ml/min/1.73m2"
#> 
calc_egfr_cystatin(1.0, method = "ckd_epi", age = 50, sex = "female")
#> $value
#> [1] 75.42894
#> 
#> $unit
#> [1] "ml/min/1.73m2"
#> 
```
