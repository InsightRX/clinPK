# Calculate eGFR or creatinine clearance

Calculate the estimated glomerular filtration rate (eGFR) or estimated
creatinine clearance (CrCl), both indicators of renal function, based on
measured serum creatinine. Note that CrCl overestimates GFR, because
creatinine is also secreted by the renal tubules, so the two are not
interchangeable. Regardless of method, the estimate is returned in the
`value` element of the output.

Most equations report values per 1.73 m2 body surface area. The
Cockcroft-Gault, Wright, and Jelliffe for unstable renal function
equations report absolute values (mL/min) instead. By default, values
are returned in the units of the equation; use `relative` to convert
between them.

Methods estimating GFR:

- Revised Lund-Malmo (`malmo_lund_revised`)

- Modification of Diet in Renal Disease study (MDRD; `mdrd`,
  `mdrd_ignore_race`, `mdrd_original`, `mdrd_original_ignore_race`),
  with or without consideration of race, using either the original
  equation (published 2001) or the equation updated to reflect serum
  creatinine assay standardization (2006)

- CKD-EPI (`ckd_epi`, `ckd_epi_ignore_race`, `ckd_epi_as_2021`), with or
  without consideration of race, or 2021 re-fit without race

- European Kidney Function Consortium (EKFC; `ekfc`). Applicable from 2
  years of age.

- Schwartz (`schwartz`)

- Schwartz revised / bedside (`schwartz_revised`, `bedside_schwartz`)

- Wright equation for eGFR in cancer patients (`wright`), with
  creatinine measured using the Jaffe assay. Reports absolute values.

Methods estimating CrCl:

- Cockcroft-Gault (`cockcroft_gault`, `cockcroft_gault_ideal`,
  `cockcroft_gault_adjusted`, `cockcroft_gault_adaptive`), using total,
  ideal, adjusted, or adaptive (see
  [`calc_dosing_weight()`](https://insightrx.github.io/clinPK/reference/calc_dosing_weight.md))
  body weight. Reports absolute values.

- C-G spinal cord injury (`cockcroft_gault_sci`), using correction
  factor of 0.7, representing median correction point reported in the
  original publication (paraplegic patients: 0.8; tetraplegic patients:
  0.6)

- Jelliffe (`jelliffe`). Reports values per 1.73 m2.

- Jelliffe for unstable renal function (`jelliffe_unstable`). Reports
  absolute values. Note that the 15% reduction in P_adj recommended for
  hemodialysis patients is not included in this implementation.

## Usage

``` r
calc_egfr(
  method = c("cockcroft_gault", "cockcroft_gault_ideal", "cockcroft_gault_adjusted",
    "cockcroft_gault_adaptive", "cockcroft_gault_sci", "mdrd", "mdrd_ignore_race",
    "mdrd_original", "mdrd_original_ignore_race", "ckd_epi", "ckd_epi_ignore_race",
    "ckd_epi_as_2021", "ekfc", "malmo_lund_revised", "schwartz", "schwartz_revised",
    "bedside_schwartz", "jelliffe", "jelliffe_unstable", "wright"),
  sex = NULL,
  age = NULL,
  scr = NULL,
  scr_unit = NULL,
  race = "other",
  weight = NULL,
  height = NULL,
  bsa = NULL,
  preterm = FALSE,
  ckd = FALSE,
  times = NULL,
  bsa_method = "dubois",
  relative = NULL,
  unit_out = "mL/min",
  verbose = TRUE,
  min_value = NULL,
  max_value = NULL,
  fail = TRUE,
  ...
)
```

## Arguments

- method:

  eGFR or CrCl estimation method, choose from `"cockcroft_gault"`,
  `"cockcroft_gault_ideal"`, `"cockcroft_gault_adjusted"`,
  `"cockcroft_gault_adaptive"`, `"cockcroft_gault_sci"`, `"mdrd"`,
  `"mdrd_ignore_race"`, `"mdrd_original"`,
  `"mdrd_original_ignore_race"`, `"ckd_epi"`, `"ckd_epi_ignore_race"`,
  `"ckd_epi_as_2021"`, `"ekfc"`, `"malmo_lund_revised"`, `"schwartz"`,
  `"schwartz_revised"`, `"bedside_schwartz"`, `"jelliffe"`,
  `"jelliffe_unstable"`, `"wright"`. Defaults to `"cockcroft_gault"`.

- sex:

  sex

- age:

  age, in years

- scr:

  serum creatinine (mg/dL)

- scr_unit:

  `"mg/dL"` or `"micromol/L"` (==`"umol/L"`)

- race:

  `"black"` or `"other"`, Required for CKD-EPI and MDRD methods for
  estimating GFR. To use these methods without race, use
  `method = "ckd_epi_ignore_race"`, `method = "ckd_epi_as_2021"`,
  `method = "mdrd_ignore_race"` or
  `method = "mdrd_original_ignore_race"`. See Note section below for
  important considerations when using race as a predictive factor in
  eGFR.

- weight:

  weight, in `kg`

- height:

  height, in `cm`, used for converting to/from BSA-normalized units.

- bsa:

  body surface area

- preterm:

  is patient preterm? Used for Schwartz method.

- ckd:

  chronic kidney disease? Used for Schwartz method.

- times:

  vector of sampling times (in days!) for creatinine (only used in
  Jelliffe equation for unstable patients)

- bsa_method:

  BSA estimation method, see
  [`calc_bsa()`](https://insightrx.github.io/clinPK/reference/calc_bsa.md)
  for details

- relative:

  `TRUE`/`FALSE`. Report eGFR as per 1.73 m2? Requires BSA if conversion
  is required. If `NULL` (default), uses the units of the equation:
  `FALSE` for the Cockcroft-Gault, Wright, and Jelliffe for unstable
  renal function equations, and `TRUE` for the others.

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

- ...:

  arguments passed on to
  [`calc_abw()`](https://insightrx.github.io/clinPK/reference/calc_abw.md)
  or
  [`calc_dosing_weight()`](https://insightrx.github.io/clinPK/reference/calc_dosing_weight.md)

## Note

The MDRD and CKD-EPI equations use race as a factor in estimation of
GFR. Racism has historically been and continues to be a problem in
medicine, with racialized patients experiencing poorer outcomes. Given
this context, the use of race in clinical algorithms should be
considered carefully ([Vyas et al., NEJM
(2020)](https://www.nejm.org/doi/10.1056/NEJMms2004740)). Provided here
are versions of the CKD-EPI and MDRD equations that do not consider the
race of the patient. Removing race from GFR estimation may lead to worse
outcomes for Black patients in some contexts ([Casal et al., The Lancet
(2021)](https://www.thelancet.com/journals/lanonc/article/PIIS1470-2045(21)00377-6/fulltext)).
On the other hand, including race in GFR estimation may also prevent
Black patients from obtaining procedures like kidney transplants
([Zelnick, et al. JAMA Netw Open.
(2021)](https://pubmed.ncbi.nlm.nih.gov/33443583/)). In 2021, the
NKF/ASN Task Force on Reassessing the Inclusion of Race in Diagnosing
Kidney Diseases published revised versions of the CKD-EPI equations
refit on the original data but with race excluded, which may produce
less biased estimates ([Inker, et al., NEJM
(2021)](https://www.nejm.org/doi/full/10.1056/NEJMoa2102953)).

## References

- Cockcroft-Gault: [Cockcroft & Gault, Nephron
  (1976)](https://pubmed.ncbi.nlm.nih.gov/1244564/)

- Cockcroft-Gault for spinal cord injury: [Mirahmadi et al., Paraplegia
  (1983)](https://pubmed.ncbi.nlm.nih.gov/6835689/)

- Revised Lund-Malmo: [Nyman et al., Clinical Chemistry and Laboratory
  Medicine (2014)](https://pubmed.ncbi.nlm.nih.gov/24334413/)

- MDRD: [Manjunath et al., Curr. Opin. Nephrol. Hypertens.
  (2001)](https://pubmed.ncbi.nlm.nih.gov/11706306/) and [Levey et al.,
  Clinical Chemistry
  (2007)](https://academic.oup.com/clinchem/article/53/4/766/5627682).
  (See Note.)

- CKD-EPI: [Levey et al., Annals of Internal Medicine
  (2009)](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC2763564/). (See
  Note.)

- CKD-EPI (2021): [Inker, et al., NEJM
  (2021)](https://www.nejm.org/doi/full/10.1056/NEJMoa2102953).

- EKFC: [Pottel et al., Annals of Internal Medicine
  (2021)](https://pubmed.ncbi.nlm.nih.gov/33166224/)

- Schwartz: [Schwartz et al., Pediatrics
  (1976)](https://pubmed.ncbi.nlm.nih.gov/951142/)

- Schwartz revised / bedside: [Schwartz et al., Journal of the American
  Society of Nephrology
  (2009)](https://pubmed.ncbi.nlm.nih.gov/19158356/)

- Jelliffe: [Jelliffe, Annals of Internal Medicine
  (1973)](https://pubmed.ncbi.nlm.nih.gov/4748282/)

- Jelliffe for unstable renal function: [Jelliffe, American Journal of
  Nephrology (2002)](https://pubmed.ncbi.nlm.nih.gov/12169862/)

- Wright: [Wright et al., British Journal of Cancer
  (2001)](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC2363765/)

## See also

- [`calc_egfr_cystatin()`](https://insightrx.github.io/clinPK/reference/calc_egfr_cystatin.md)
  for equations using cystatin C alone

- [`calc_egfr_combined()`](https://insightrx.github.io/clinPK/reference/calc_egfr_combined.md)
  for equations using both creatinine and cystatin C

## Examples

``` r
calc_egfr(sex = "male", age = 50, scr = 1.1, weight = 70)
#> Creatinine unit not specified, assuming mg/dL.
#> $value
#> [1] 79.54545
#> 
#> $age
#> [1] 50
#> 
#> $bsa
#> NULL
#> 
#> $sex
#> [1] "male"
#> 
#> $scr
#> [1] 1.1
#> 
#> $unit
#> [1] "ml/min"
#> 
#> $weight
#> [1] "Total BW"
#> 
#> $capped
#> list()
#> 
calc_egfr(sex = "male", age = 50, scr = 1.1, weight = 70, unit_out = "L/hr")
#> Creatinine unit not specified, assuming mg/dL.
#> $value
#> [1] 4.772727
#> 
#> $age
#> [1] 50
#> 
#> $bsa
#> NULL
#> 
#> $sex
#> [1] "male"
#> 
#> $scr
#> [1] 1.1
#> 
#> $unit
#> [1] "l/hr"
#> 
#> $weight
#> [1] "Total BW"
#> 
#> $capped
#> list()
#> 
calc_egfr(sex = "male", age = 50, scr = 1.1, weight = 70, bsa = 1.8, method = "ckd_epi")
#> Creatinine unit not specified, assuming mg/dL.
#> $value
#> [1] 77.86046
#> 
#> $age
#> [1] 50
#> 
#> $bsa
#> [1] 1.8
#> 
#> $sex
#> [1] "male"
#> 
#> $scr
#> [1] 1.1
#> 
#> $unit
#> [1] "ml/min/1.73m^2"
#> 
#> $weight
#> [1] "Total BW"
#> 
#> $capped
#> list()
#> 
calc_egfr(sex = "male", age = 50, scr = c(1.1, 0.8),
  weight = 70, height = 170, method = "jelliffe")
#> Creatinine unit not specified, assuming mg/dL.
#> $value
#> [1] 67.27273 92.50000
#> 
#> $age
#> [1] 50
#> 
#> $bsa
#> NULL
#> 
#> $sex
#> [1] "male"
#> 
#> $scr
#> [1] 1.1 0.8
#> 
#> $unit
#> [1] "ml/min/1.73m^2"
#> 
#> $weight
#> [1] "Total BW"
#> 
#> $capped
#> list()
#> 
calc_egfr(sex = "male", age = 50, scr = c(1.1, 0.8),
  weight = 70, height = 170, method = "jelliffe_unstable")
#> Creatinine unit not specified, assuming mg/dL.
#> $value
#> [1] 80.41714 99.72645
#> 
#> $age
#> [1] 50
#> 
#> $bsa
#> NULL
#> 
#> $sex
#> [1] "male"
#> 
#> $scr
#> [1] 1.1 0.8
#> 
#> $unit
#> [1] "ml/min"
#> 
#> $weight
#> [1] "Total BW"
#> 
#> $capped
#> list()
#> 
calc_egfr(sex = "male", age = 50, scr = 1.1,
  weight = 70, bsa = 1.6, method = "malmo_lund_revised", relative = FALSE)
#> Creatinine unit not specified, assuming mg/dL.
#> $value
#> [1] 67.11891
#> 
#> $age
#> [1] 50
#> 
#> $bsa
#> [1] 1.6
#> 
#> $sex
#> [1] "male"
#> 
#> $scr
#> [1] 1.1
#> 
#> $unit
#> [1] "ml/min"
#> 
#> $weight
#> [1] "Total BW"
#> 
#> $capped
#> list()
#> 
calc_egfr(sex = "female", age = 50, scr = 0.9, method = "ekfc")
#> Creatinine unit not specified, assuming mg/dL.
#> $value
#> [1] 73.17329
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
#> $unit
#> [1] "ml/min/1.73m^2"
#> 
#> $weight
#> [1] "Total BW"
#> 
#> $capped
#> list()
#> 
```
