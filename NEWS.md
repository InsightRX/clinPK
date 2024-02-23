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
