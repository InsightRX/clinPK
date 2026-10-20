# clinPK 0.14.0 (development version)

## Major changes
- Refactored `pct_*_for_*()` functions. As input, they now accept vectors of values. They now return either a vector of percentiles for the given physical measurement, or a data frame with the observed percentile for the given physical measurement, along with a select distribution of physical measurements at particular percentiles. These functions also use updated CDC growth charts instead of WHO growth charts.
- Added `median_*_for_*()` functions for calculating median growth values for infants and children. These functions replace the now-deprecated `return_median` argument in the `pct_*_for_*()` functions.
- Added CDC growth chart data sets as package data (see `?"growth-charts"`).
- Removed `read_who_table()` function, as part of the refactor for the `pct_*_for_*()` functions.
- Added `calc_treosulfan_success()` function.
- Added `calc_egfr_combined()` function for estimating eGFR from both creatinine and cystatin C, supporting the CKD-EPI (2021, without race) and EKFC equations.
- Added European Kidney Function Consortium (EKFC) eGFR equations: creatinine-based (`calc_egfr(method = "ekfc")`), cystatin C-based (`calc_egfr_cystatin(method = "ekfc")`), and the mean of both (`calc_egfr_combined(method = "ekfc")`).
- Added CKD-EPI cystatin C equation (2012) (`calc_egfr_cystatin(method = "ckd_epi")`). `calc_egfr_cystatin()` gains `age`, `sex`, and `verbose` arguments.

## Minor updates
- Activated roxygen's markdown parser for improved function documentation
- `calc_egfr_cystatin()` now errors if `cystatin_unit` is not `mg/L`. Previously, other units were silently ignored.
- `calc_egfr()` now validates `method` with `match.arg()`, so the available methods are listed in its usage. Unrecognized methods now give `match.arg()`'s error message, and unambiguous partial method names are accepted.
- `egfr_cov_reqs()` now returns the canonical method name (`"malmo_lund_revised"`) for Lund-Malmo aliases.
- `calc_egfr()` now supports vectors of `race` for the CKD-EPI and MDRD methods, and vectors of `age` for the bedside Schwartz method. Previously these errored.
- `calc_egfr()` and `calc_egfr_combined()` now error if `unit_out` is not one of `"mL/min"`, `"mL/hr"`, `"L/min"`, or `"L/hr"`. Previously, unrecognized units were silently treated as mL/min.
- `calc_egfr_cystatin()`'s `unit_out` now defaults to `NULL`, which picks `"ml/min"` for the Larsson method, and `"ml/min/1.73m2"` for the Grubb, Hoek, EKFC, and CKD-EPI methods. Previously, the Hoek method errored unless `unit_out` was set.
- **Breaking change:** `calc_egfr()` now handles absolute and relative (per 1.73 m2) eGFR correctly for the Jelliffe and Wright methods. Previously, all methods other than Cockcroft-Gault were assumed to report values per 1.73 m2.
  - `method = "wright"` and `method = "jelliffe_unstable"` report absolute values (mL/min), as in the original publications. They now default to `relative = FALSE` (like Cockcroft-Gault) and are labelled correctly. Previously, they were labelled as per 1.73 m2, and `relative = FALSE` scaled them by BSA a second time. This also affected `calc_carboplatin_calvert()` with these methods, which overestimated doses.
  - `method = "jelliffe"` now reports values per 1.73 m2, as in the original publication (Jelliffe, 1973). Previously, values were multiplied by BSA/1.73 but labelled as per 1.73 m2, and `relative = FALSE` scaled them by BSA a second time. BSA is now only required when `relative = FALSE`.
  - `method = "jelliffe"` now uses a factor of 0.9 for females, as in the original publication. Previously, it used 0.99.
- **Breaking change:** `calc_egfr_cystatin(method = "grubb")` now reports eGFR in mL/min/1.73m2, as in the original publication (Grubb et al., Clinical Chemistry, 2005). Previously, it was labelled as absolute eGFR (mL/min) and could be converted to other absolute units, which was incorrect. The calculated values are unchanged, but the Grubb method now only supports `unit_out = "ml/min/1.73m2"`.
- Added references for the Grubb, Larsson, and Hoek methods to the `calc_egfr_cystatin()` documentation, along with a note that these equations were developed with cystatin C assays calibrated before international standardization.
- `calc_egfr_cystatin()` now warns when the Grubb or CKD-EPI methods are used for patients < 18 years of age, since these equations were developed in adults. For the Grubb method, `age` is optional and only used for this warning.

# clinPK 0.13.0

## Major changes
- Added support for converting bilirubin and albumin units
- Added support for Calvert equation for carboplatin
- Added function for grading neutropenia

## Minor updates
- Added support for Hoek eGFR method
- Vectorize `weight2kg()` over both units and values

# clinPK 0.11.1

## Major changes
- various corrections in nca() function
- various updates to AKI staging equations: MDRD equation (use 2006 publication), kDIGO and PRIFLE
- added equations of MDRD and CKD-EPI without race

## Minor updates
- refactor of calc_ibw()
- fixed Boyd equation in calc_bsa()
- added function to convert flow units
- updates to 2-sample equation
- added Cockcroft-Gault equation for spinal cord injury patients
- consistent handling of missing/unrecognized data in `calc_ibw()`/`calc_ffm()`/`calc_egfr()`
- various minor fixes and updates
- various documentation updates
- added many unit tests, increase overall coverage to >86%

# clinPK 0.9.0

Initial CRAN version.
