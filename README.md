[![Build Status](https://travis-ci.org/ronkeizer/clinPK.svg?branch=master)](https://travis-ci.org/ronkeizer/clinPK)
[![codecov](https://codecov.io/gh/ronkeizer/clinPK/branch/master/graph/badge.svg)](https://codecov.io/gh/ronkeizer/clinPK)

# clinPK

Equations and tools for clinical pharmacokinetics

## Miscellaneous functions

- `nca()`: Non-compartmental PK analysis, e.g. AUC, half-life, etc.
- `calc_kel_single_tdm()`: calculate elimination rate (for linear 1-cmt model) based on single TDM sample and provided volume of distribution.
- `calc_t12()`: calculate effective half-life based on two TDM points.
- `calc_amts_for_conc()`: Calculate the amounts in all compartments in a compartmental PK system based on a given concentration in the central compartment, and assuming steady state.
- `find_nearest_dose()`: Find nearest available dose based on smallest available dosing unit
- `find_nearest_interval()`: Find nearest (or nearest higher / nearest lower) dosing interval 

## Anthropomorphic equations

- `calc_bsa()`: BSA calculation using various equations
- `calc_ffm()`: Fat-free mass using various equations
- `calc_bmi()`: Body mass index
- `calc_ibw()`: Ideal body weight, using various equations for children and adults
- `calc_lbw()`: Lean body weight
- `calc_abw()`: Adjusted body weight (for obese patients)
- `pct_weight_for_age()`: calculate percentile of weight given age (for kids <= 10 yrs)
- `pct_height_for_age()`: calculate percentile of height given age (for kids <= 19 yrs)
- `pct_bmi_for_age()`: calculate percentile of height given age (for kids <= 19 yrs)

## Clinical chemistry

- `calc_egfr()`: eGFR calculation from serum creatinine using various equations (Cockcroft-Gault, MDRD, CKD-EPI, Jelliffe, Jelliffe for unstable patients, Wright, Lund-Malmo revised, Schwartz, Schwartz revised)
- `calc_egfr_cystatin()`: eGFR calculation from Cystatin C concentrations using various equations (Grubb, Larsson)
- `calc_creat()`: mean serum creatinine for children and adults (given age and sex)
- `calc_creat_neo()`: typical serum creatinine for neonates given post-natal age
- `convert_creat_assay()`: convert between various creatinine assays (Jaffe, IDMS, etc)
- `convert_creat_unit()`: convert between creatinine units (mmol/L, mg/dL)

## Conversions

- `kg2lbs()`: kg to pounds
- `lbs2kg()`: pounds to kg
- `weight2kg()`: any weight unit to kg
- `cm2inch()`: cm to inches
- `inch2cm()`: inches to cm
- `conc2mol()`: concentration to molar
- `mol2conc()`: molar to concentration

## PK compartmental equations

Functions to simulate concentrations for linear PK models.

| function | compartments | administration | type | output |
| --- | --- | --- | --- | --- |
| `pk_1cmt_inf()` | 1 | infusion | single/multi dose | concentration table |
| `pk_1cmt_inf_ss()` | 1 | infusion | steady state | concentration table |
| `pk_1cmt_inf_cmin_ss()` | 1 | infusion | steady state | Cmin |
| `pk_1cmt_inf_cmax_ss()` | 1 | infusion | steady state | Cmax |
| `pk_2cmt_inf()` | 2 | infusion | single/multi dose | concentration table |
| `pk_2cmt_inf_ss()` | 2 | infusion | steady state | concentration table |
| `pk_2cmt_inf_cmin_ss()` | 2 | infusion | steady state | Cmin |
| `pk_2cmt_inf_cmax_ss()` | 2 | infusion | steady state | Cmax |
| `pk_1cmt_bolus()` | 1 | bolus | single/multi dose | concentration table |
| `pk_1cmt_bolus_ss()` | 1 | bolus | steady state | concentration table |
| `pk_1cmt_bolus_cmin_ss()` | 1 | bolus | steady state | Cmin |
| `pk_1cmt_bolus_cmax_ss()` | 1 | bolus | steady state | Cmax |
| `pk_1cmt_t12()` | 1 | - | - | half-life |
| `pk_2cmt_bolus()` | 2 | bolus | single/multi dose | concentration table |
| `pk_2cmt_bolus_ss()` | 2 | bolus | steady state | concentration table |
| `pk_2cmt_bolus_cmin_ss()` | 2 | bolus | steady state | Cmin |
| `pk_2cmt_bolus_cmax_ss()` | 2 | bolus | steady state | Cmax |
| `pk_2cmt_t12()` | 2 | - | - | terminal half-life |
| `pk_2cmt_t12_interval()` | 2 | - | - | effective half-life in given interval |

## Dose / TDM calculations

Functions to calculate the dose expected to achieve a specific target exposure.

| function | compartments | administration | target | output |
| --- | --- | --- | --- | --- |
| `pk_1cmt_inf_dose_for_cmin` | 1 | infusion | cmin | dose |
| `pk_1cmt_bolus_dose_for_cmin` | 1 | bolus | cmin | dose |
| `pk_2cmt_inf_dose_for_cmin()` | 2 | infusion | cmin | dose |
| `pk_2cmt_bolus_dose_for_cmin()` | 2 | bolus | cmin | dose |
| `pk_1cmt_inf_dose_for_cmax` | 1 | infusion | cmax | dose |
| `pk_1cmt_bolus_dose_for_cmax` | 1 | bolus | cmax | dose |
| `pk_2cmt_inf_dose_for_cmax()` | 2 | infusion | cmax | dose |
| `pk_2cmt_bolus_dose_for_cmax()` | 2 | bolus | cmax | dose |
| `dose2auc()` | 1 | - | auc | auc |
| `auc2dose()` | 1 | - | auc | dose |

