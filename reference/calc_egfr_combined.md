# Calculate eGFR based on creatinine and cystatin C measurements

Calculate the estimated glomerular filtration rate based on both
measured serum creatinine and serum cystatin C using one of the
following approaches:

- CKD-EPI creatinine-cystatin C (2021 re-fit without race). Developed in
  adults (\>= 18 years) only.

- European Kidney Function Consortium (EKFC): the arithmetic mean of the
  creatinine-based and cystatin C-based EKFC equations. The cystatin
  C-based equation was validated in adults (\>= 18 years) only.

## Usage

``` r
calc_egfr_combined(
  method = c("ckd_epi_as_2021", "ekfc"),
  sex = NULL,
  age = NULL,
  scr = NULL,
  scr_unit = NULL,
  cystatin = NULL,
  cystatin_unit = "mg/L",
  weight = NULL,
  height = NULL,
  bsa = NULL,
  bsa_method = "dubois",
  relative = TRUE,
  unit_out = "mL/min",
  verbose = TRUE,
  min_value = NULL,
  max_value = NULL,
  fail = TRUE
)
```

## Arguments

- method:

  eGFR estimation method, choose from `"ckd_epi_as_2021"`, `"ekfc"`.

- sex:

  sex

- age:

  age, in years

- scr:

  serum creatinine (mg/dL)

- scr_unit:

  `"mg/dL"` or `"micromol/L"` (==`"umol/L"`)

- cystatin:

  serum cystatin C concentration (mg/L)

- cystatin_unit:

  only `"mg/L"` available

- weight:

  weight, in `kg`, used for converting to absolute units.

- height:

  height, in `cm`, used for converting to absolute units.

- bsa:

  body surface area, used for converting to absolute units.

- bsa_method:

  BSA estimation method, see
  [`calc_bsa()`](https://insightrx.github.io/clinPK/reference/calc_bsa.md)
  for details

- relative:

  `TRUE`/`FALSE`. Report eGFR as per 1.73 m2? If `FALSE`, requires
  `bsa`, or `weight` and `height` to calculate it.

- unit_out:

  `"mL/min"` (default), `"mL/hr"`, `"L/min"`, or `"L/hr"`
  (case-insensitive)

- verbose:

  verbosity, show guidance and warnings. `TRUE` by default

- min_value:

  minimum value (`NULL` by default). The cap is applied in the same unit
  as the `unit_out`.

- max_value:

  maximum value (`NULL` by default). The cap is applied in the same unit
  as the `unit_out`.

- fail:

  invoke [`stop()`](https://rdrr.io/r/base/stop.html) if not all
  covariates available?

## References

- CKD-EPI (2021): [Inker, et al., NEJM
  (2021)](https://www.nejm.org/doi/full/10.1056/NEJMoa2102953).

- EKFC: [Pottel et al., NEJM
  (2023)](https://www.nejm.org/doi/full/10.1056/NEJMoa2203769)

## See also

- [`calc_egfr()`](https://insightrx.github.io/clinPK/reference/calc_egfr.md)
  for equations using creatinine alone

- [`calc_egfr_cystatin()`](https://insightrx.github.io/clinPK/reference/calc_egfr_cystatin.md)
  for equations using cystatin C alone

## Examples

``` r
calc_egfr_combined(sex = "female", age = 50, scr = 0.9, cystatin = 1.1)
#> Creatinine unit not specified, assuming mg/dL.
#> $value
#> [1] 72.80027
#> 
#> $age
#> [1] 50
#> 
#> $bsa
#> NULL
#> 
#> $sex
#> [1] "female"
#> 
#> $scr
#> [1] 0.9
#> 
#> $cystatin
#> [1] 1.1
#> 
#> $unit
#> [1] "ml/min/1.73m^2"
#> 
#> $capped
#> list()
#> 
calc_egfr_combined(sex = "female", age = 50, scr = 0.9, cystatin = 1.1,
  method = "ekfc")
#> Creatinine unit not specified, assuming mg/dL.
#> $value
#> [1] 71.8612
#> 
#> $age
#> [1] 50
#> 
#> $bsa
#> NULL
#> 
#> $sex
#> [1] "female"
#> 
#> $scr
#> [1] 0.9
#> 
#> $cystatin
#> [1] 1.1
#> 
#> $unit
#> [1] "ml/min/1.73m^2"
#> 
#> $capped
#> list()
#> 
calc_egfr_combined(sex = "female", age = 50, scr = 0.9, cystatin = 1.1,
  weight = 70, height = 165, relative = FALSE, unit_out = "L/hr")
#> Creatinine unit not specified, assuming mg/dL.
#> $value
#> [1] 4.471435
#> 
#> $age
#> [1] 50
#> 
#> $bsa
#> [1] 1.77096
#> 
#> $sex
#> [1] "female"
#> 
#> $scr
#> [1] 0.9
#> 
#> $cystatin
#> [1] 1.1
#> 
#> $unit
#> [1] "l/hr"
#> 
#> $capped
#> list()
#> 
```
