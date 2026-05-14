# Changelog

## clinPK 0.14.0 (development version)

### Major changes

- Refactored `pct_*_for_*()` functions. As input, they now accept
  vectors of values. They now return either a vector of percentiles for
  the given physical measurement, or a data frame with the observed
  percentile for the given physical measurement, along with a select
  distribution of physical measurements at particular percentiles. These
  functions also use updated CDC growth charts instead of WHO growth
  charts.
- Added `median_*_for_*()` functions for calculating median growth
  values for infants and children. These functions replace the
  now-deprecated `return_median` argument in the `pct_*_for_*()`
  functions.
- Added CDC growth chart data sets as package data (see
  [`?"growth-charts"`](https://insightrx.github.io/clinPK/reference/growth-charts.md)).
- Removed `read_who_table()` function, as part of the refactor for the
  `pct_*_for_*()` functions.
- Added
  [`calc_treosulfan_success()`](https://insightrx.github.io/clinPK/reference/calc_treosulfan_success.md)
  function.

### Minor updates

- Activated roxygen’s markdown parser for improved function
  documentation

## clinPK 0.13.0

CRAN release: 2024-02-23

### Major changes

- Added support for converting bilirubin and albumin units
- Added support for Calvert equation for carboplatin
- Added function for grading neutropenia

### Minor updates

- Added support for Hoek eGFR method
- Vectorize
  [`weight2kg()`](https://insightrx.github.io/clinPK/reference/weight2kg.md)
  over both units and values

## clinPK 0.11.1

CRAN release: 2022-05-09

### Major changes

- various corrections in nca() function
- various updates to AKI staging equations: MDRD equation (use 2006
  publication), kDIGO and PRIFLE
- added equations of MDRD and CKD-EPI without race

### Minor updates

- refactor of calc_ibw()
- fixed Boyd equation in calc_bsa()
- added function to convert flow units
- updates to 2-sample equation
- added Cockcroft-Gault equation for spinal cord injury patients
- consistent handling of missing/unrecognized data in
  [`calc_ibw()`](https://insightrx.github.io/clinPK/reference/calc_ibw.md)/[`calc_ffm()`](https://insightrx.github.io/clinPK/reference/calc_ffm.md)/[`calc_egfr()`](https://insightrx.github.io/clinPK/reference/calc_egfr.md)
- various minor fixes and updates
- various documentation updates
- added many unit tests, increase overall coverage to \>86%

## clinPK 0.9.0

CRAN release: 2017-06-19

Initial CRAN version.
