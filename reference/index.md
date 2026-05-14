# Package index

## Anthropomorphic equations

- [`calc_bsa()`](https://insightrx.github.io/clinPK/reference/calc_bsa.md)
  : Calculate body surface area
- [`calc_ffm()`](https://insightrx.github.io/clinPK/reference/calc_ffm.md)
  : Calculate fat-free mass
- [`calc_bmi()`](https://insightrx.github.io/clinPK/reference/calc_bmi.md)
  : Calculate BMI
- [`calc_ibw()`](https://insightrx.github.io/clinPK/reference/calc_ibw.md)
  [`ibw_standard()`](https://insightrx.github.io/clinPK/reference/calc_ibw.md)
  [`ibw_devine()`](https://insightrx.github.io/clinPK/reference/calc_ibw.md)
  : Calculate ideal body weight in kg for children and adults
- [`calc_lbw()`](https://insightrx.github.io/clinPK/reference/calc_lbw.md)
  : Calculate lean body weight
- [`calc_abw()`](https://insightrx.github.io/clinPK/reference/calc_abw.md)
  : Calculate adjusted body weight (ABW)
- [`calc_dosing_weight()`](https://insightrx.github.io/clinPK/reference/calc_dosing_weight.md)
  : Calculate commonly used "dosing weight"
- [`calc_baseline_scr()`](https://insightrx.github.io/clinPK/reference/calc_baseline_scr.md)
  : Calculate baseline sCr
- [`pct_weight_for_age()`](https://insightrx.github.io/clinPK/reference/pct_x_for_y.md)
  [`pct_height_for_age()`](https://insightrx.github.io/clinPK/reference/pct_x_for_y.md)
  [`pct_bmi_for_age()`](https://insightrx.github.io/clinPK/reference/pct_x_for_y.md)
  [`pct_weight_for_height()`](https://insightrx.github.io/clinPK/reference/pct_x_for_y.md)
  : Growth percentiles for infants and children
- [`median_weight_for_age()`](https://insightrx.github.io/clinPK/reference/median_x_for_y.md)
  [`median_height_for_age()`](https://insightrx.github.io/clinPK/reference/median_x_for_y.md)
  [`median_bmi_for_age()`](https://insightrx.github.io/clinPK/reference/median_x_for_y.md)
  [`median_weight_for_height()`](https://insightrx.github.io/clinPK/reference/median_x_for_y.md)
  : Median growth values for infants and children

## Clinical chemistry

- [`calc_egfr()`](https://insightrx.github.io/clinPK/reference/calc_egfr.md)
  : Calculate eGFR
- [`calc_egfr_cystatin()`](https://insightrx.github.io/clinPK/reference/calc_egfr_cystatin.md)
  : Calculate eGFR based on Cystatin C measurements
- [`calc_kgfr()`](https://insightrx.github.io/clinPK/reference/calc_kgfr.md)
  : Calculate kinetic GFR
- [`calc_creat()`](https://insightrx.github.io/clinPK/reference/calc_creat.md)
  : Estimate serum creatinine
- [`calc_creat_neo()`](https://insightrx.github.io/clinPK/reference/calc_creat_neo.md)
  : Estimate serum creatinine in neonates
- [`calc_aki_stage()`](https://insightrx.github.io/clinPK/reference/calc_aki_stage.md)
  : Calculate AKI stage
- [`calc_neutropenia_grade()`](https://insightrx.github.io/clinPK/reference/calc_neutropenia_grade.md)
  : Calculate neutropenia grade from ANC

## Conversions

- [`kg2lbs()`](https://insightrx.github.io/clinPK/reference/kg2lbs.md) :
  Convert kg to lbs
- [`lbs2kg()`](https://insightrx.github.io/clinPK/reference/lbs2kg.md) :
  Convert lbs to kg
- [`kg2oz()`](https://insightrx.github.io/clinPK/reference/kg2oz.md) :
  Convert kg to oz
- [`oz2kg()`](https://insightrx.github.io/clinPK/reference/oz2kg.md) :
  Convert oz to kg
- [`weight2kg()`](https://insightrx.github.io/clinPK/reference/weight2kg.md)
  : Convert any weight unit to kg
- [`cm2inch()`](https://insightrx.github.io/clinPK/reference/cm2inch.md)
  : Convert cm to inch
- [`inch2cm()`](https://insightrx.github.io/clinPK/reference/inch2cm.md)
  : Convert inch to cm
- [`conc2mol()`](https://insightrx.github.io/clinPK/reference/conc2mol.md)
  : Convert concentration to molar
- [`mol2conc()`](https://insightrx.github.io/clinPK/reference/mol2conc.md)
  : Convert molar to concentration
- [`absolute2relative_bsa()`](https://insightrx.github.io/clinPK/reference/absolute2relative_bsa.md)
  : Convert quantity expressed in absolute units relative to normalized
  BSA
- [`relative2absolute_bsa()`](https://insightrx.github.io/clinPK/reference/relative2absolute_bsa.md)
  : Convert quantity expressed relative to BSA to absolute units
- [`convert_flow_unit()`](https://insightrx.github.io/clinPK/reference/convert_flow_unit.md)
  : Convert flow (e.g. clearance) from / to units
- [`convert_albumin_unit()`](https://insightrx.github.io/clinPK/reference/convert_albumin_unit.md)
  : Convert albumin from / to units
- [`convert_creat_assay()`](https://insightrx.github.io/clinPK/reference/convert_creat_assay.md)
  : Convert serum creatinine from various assays to Jaffe
- [`convert_creat_unit()`](https://insightrx.github.io/clinPK/reference/convert_creat_unit.md)
  : Convert creatinine to different unit
- [`convert_bilirubin_unit()`](https://insightrx.github.io/clinPK/reference/convert_bilirubin_unit.md)
  : Convert bilirubin from / to units

## PK compartmental equations

Functions to simulate concentrations for linear PK models.

- [`pk_1cmt_inf()`](https://insightrx.github.io/clinPK/reference/pk_1cmt_inf.md)
  : Concentration predictions for 1-compartmental PK model after single
  or multiple bolus doses
- [`pk_1cmt_inf_ss()`](https://insightrx.github.io/clinPK/reference/pk_1cmt_inf_ss.md)
  : Concentration predictions for 2-compartmental PK model with infusion
  dosing at steady state
- [`pk_1cmt_inf_cmin_ss()`](https://insightrx.github.io/clinPK/reference/pk_1cmt_inf_cmin_ss.md)
  : Cmin (trough) for linear 1-compartment PK model at steady state
- [`pk_1cmt_inf_cmax_ss()`](https://insightrx.github.io/clinPK/reference/pk_1cmt_inf_cmax_ss.md)
  : Cmax for linear 1-compartment PK model at steady state
- [`pk_2cmt_inf()`](https://insightrx.github.io/clinPK/reference/pk_2cmt_inf.md)
  : Concentration predictions for 2-compartmental PK model, single or
  multiple infusions
- [`pk_2cmt_inf_ss()`](https://insightrx.github.io/clinPK/reference/pk_2cmt_inf_ss.md)
  : Concentration predictions for 2-compartmental PK model with infusion
  dosing at steady state
- [`pk_2cmt_inf_cmin_ss()`](https://insightrx.github.io/clinPK/reference/pk_2cmt_inf_cmin_ss.md)
  : Cmin (trough) for 2-compartmental PK model, bolus dosing at steady
  state
- [`pk_2cmt_inf_cmax_ss()`](https://insightrx.github.io/clinPK/reference/pk_2cmt_inf_cmax_ss.md)
  : Cmax (trough) for 2-compartmental PK model, bolus dosing at steady
  state
- [`pk_1cmt_bolus()`](https://insightrx.github.io/clinPK/reference/pk_1cmt_bolus.md)
  : Concentration predictions for 1-compartmental PK model after single
  or multiple bolus doses
- [`pk_1cmt_bolus_ss()`](https://insightrx.github.io/clinPK/reference/pk_1cmt_bolus_ss.md)
  : Concentration predictions for 1-compartmental PK model with bolus
  dosing at steady state
- [`pk_1cmt_bolus_cmin_ss()`](https://insightrx.github.io/clinPK/reference/pk_1cmt_bolus_cmin_ss.md)
  : Cmin (trough) for linear 1-compartment PK model at steady state,
  bolus dosing
- [`pk_1cmt_bolus_cmax_ss()`](https://insightrx.github.io/clinPK/reference/pk_1cmt_bolus_cmax_ss.md)
  : Cmax for linear 1-compartment PK model at steady state, bolus dosing
- [`pk_1cmt_t12()`](https://insightrx.github.io/clinPK/reference/pk_1cmt_t12.md)
  : Calculate terminal half-life for 1-compartment model
- [`pk_1cmt_oral()`](https://insightrx.github.io/clinPK/reference/pk_1cmt_oral.md)
  : Concentration predictions for 1-compartmental oral PK model after
  single or multiple bolus doses
- [`pk_2cmt_bolus()`](https://insightrx.github.io/clinPK/reference/pk_2cmt_bolus.md)
  : Concentration predictions for 2-compartmental PK model, single or
  multiple bolus doses
- [`pk_2cmt_bolus_ss()`](https://insightrx.github.io/clinPK/reference/pk_2cmt_bolus_ss.md)
  : Concentration predictions for 2-compartmental PK model, bolus dosing
  at steady state
- [`pk_2cmt_bolus_cmin_ss()`](https://insightrx.github.io/clinPK/reference/pk_2cmt_bolus_cmin_ss.md)
  : Cmin (trough) for 2-compartmental PK model, bolus dosing at steady
  state
- [`pk_2cmt_bolus_cmax_ss()`](https://insightrx.github.io/clinPK/reference/pk_2cmt_bolus_cmax_ss.md)
  : Cmax for 2-compartmental PK model, bolus dosing at steady state
- [`pk_2cmt_t12()`](https://insightrx.github.io/clinPK/reference/pk_2cmt_t12.md)
  : Calculate half-life(s) for 2-compartment model
- [`pk_2cmt_t12_interval()`](https://insightrx.github.io/clinPK/reference/pk_2cmt_t12_interval.md)
  : Calculate average half-life for 2-compartment model during a
  specific interval

## PK steady state equations

- [`accumulation_ratio()`](https://insightrx.github.io/clinPK/reference/accumulation_ratio.md)
  : Calculate accumulation ratio This is the ratio of drug concentration
  or AUC at steady state over concentrations after single dose
- [`fraction_of_ss()`](https://insightrx.github.io/clinPK/reference/fraction_of_ss.md)
  : Calculate fraction of steady state at particular time after start of
  dosing
- [`time_to_ss()`](https://insightrx.github.io/clinPK/reference/time_to_ss.md)
  : Time to steady state In either time units or number of doses

## Dose/TDM calculations

Functions to calculate the dose expected to achieve a specific target
exposure.

- [`pk_1cmt_inf_dose_from_cmin()`](https://insightrx.github.io/clinPK/reference/pk_1cmt_inf_dose_from_cmin.md)
  : Calculate dose to achieve steady state trough for 1-compartmental PK
  model with infusion dosing at steady state
- [`pk_1cmt_bolus_dose_from_cmin()`](https://insightrx.github.io/clinPK/reference/pk_1cmt_bolus_dose_from_cmin.md)
  : Calculate dose to achieve steady state trough for 1-compartmental PK
  model bolus dosing at steady state
- [`pk_2cmt_inf_dose_from_cmin()`](https://insightrx.github.io/clinPK/reference/pk_2cmt_inf_dose_from_cmin.md)
  : Calculate dose to achieve steady state trough for 2-compartmental PK
  model with infusion dosing at steady state
- [`pk_2cmt_bolus_dose_from_cmin()`](https://insightrx.github.io/clinPK/reference/pk_2cmt_bolus_dose_from_cmin.md)
  : Calculate dose to achieve steady state trough for 2-compartmental PK
  model bolus dosing at steady state
- [`pk_1cmt_inf_dose_from_cmax()`](https://insightrx.github.io/clinPK/reference/pk_1cmt_inf_dose_from_cmax.md)
  : Calculate dose to achieve steady state Cmax for 1-compartmental PK
  model with infusion dosing at steady state
- [`pk_1cmt_bolus_dose_from_cmax()`](https://insightrx.github.io/clinPK/reference/pk_1cmt_bolus_dose_from_cmax.md)
  : Calculate dose to achieve steady state Cmax for 1-compartmental PK
  model bolus dosing at steady state
- [`pk_2cmt_inf_dose_from_cmax()`](https://insightrx.github.io/clinPK/reference/pk_2cmt_inf_dose_from_cmax.md)
  : Calculate dose to achieve steady state Cmax for 2-compartmental PK
  model with infusion dosing at steady state
- [`pk_2cmt_bolus_dose_from_cmax()`](https://insightrx.github.io/clinPK/reference/pk_2cmt_bolus_dose_from_cmax.md)
  : Calculate dose to achieve steady state Cmax for 2-compartmental PK
  model bolus dosing at steady state
- [`pk_1cmt_inf_dose_for_range()`](https://insightrx.github.io/clinPK/reference/pk_1cmt_inf_dose_for_range.md)
  : Calculate dose based on a given AUC24, Cmax, and Cmin, assuming
  1-compartment model
- [`dose2auc()`](https://insightrx.github.io/clinPK/reference/dose2auc.md)
  : Convert dose to expected AUCinf or AUCt for 1 compartment linear PK
  model
- [`auc2dose()`](https://insightrx.github.io/clinPK/reference/auc2dose.md)
  : Convert AUCtau or AUCt to dose (for 1-compartment linear PK model)

## Probability calculations

Functions to calculate outcome probabilities.

- [`calc_cefepime_neurotoxicity()`](https://insightrx.github.io/clinPK/reference/calc_cefepime_neurotoxicity.md)
  : Calculate Cefepime-associated Neurotoxicity
- [`calc_treosulfan_success()`](https://insightrx.github.io/clinPK/reference/calc_treosulfan_success.md)
  : Calculate probability of therapeutic success for treosulfan

## Miscellaneous functions

- [`nca()`](https://insightrx.github.io/clinPK/reference/nca.md) :
  Perform an NCA based on a NONMEM-style dataset
- [`egfr_cov_reqs()`](https://insightrx.github.io/clinPK/reference/egfr_cov_reqs.md)
  : Returns parameters needed to calculate eGFR according to the method
  specified.
- [`check_covs_available()`](https://insightrx.github.io/clinPK/reference/check_covs_available.md)
  : Checks whether required covariates for eGFR calculations are present
- [`calc_carboplatin_calvert()`](https://insightrx.github.io/clinPK/reference/calc_carboplatin_calvert.md)
  : Calvert equation for carboplatin
- [`calc_kel_single_tdm()`](https://insightrx.github.io/clinPK/reference/calc_kel_single_tdm.md)
  : Calculate elimination rate when given a single TDM sample
- [`calc_kel_double_tdm()`](https://insightrx.github.io/clinPK/reference/calc_kel_double_tdm.md)
  : Calculate elimination rate when given two TDM samples
- [`calc_t12()`](https://insightrx.github.io/clinPK/reference/calc_t12.md)
  : Calculate half-life based on two points
- [`calc_amts_for_conc()`](https://insightrx.github.io/clinPK/reference/calc_amts_for_conc.md)
  : Calculate the amounts in all compartments in a compartmental PK
  system based on a given concentration in the central compartment, and
  assuming steady state.
- [`find_nearest_dose()`](https://insightrx.github.io/clinPK/reference/find_nearest_dose.md)
  : Generic function to calculate the dose nearest to a specific dose
  unit increment
- [`find_nearest_interval()`](https://insightrx.github.io/clinPK/reference/find_nearest_interval.md)
  : Generic function to calculate the interval nearest to a possible
  dosing interval
- [`valid_units()`](https://insightrx.github.io/clinPK/reference/valid_units.md)
  : Valid units
- [`add_ruv()`](https://insightrx.github.io/clinPK/reference/add_ruv.md)
  : Add residual variability to data

## Data sets

- [`weight_for_age`](https://insightrx.github.io/clinPK/reference/growth-charts.md)
  [`height_for_age`](https://insightrx.github.io/clinPK/reference/growth-charts.md)
  [`bmi_for_age_children`](https://insightrx.github.io/clinPK/reference/growth-charts.md)
  [`weight_for_height_infants`](https://insightrx.github.io/clinPK/reference/growth-charts.md)
  [`weight_for_height_children`](https://insightrx.github.io/clinPK/reference/growth-charts.md)
  : CDC Growth Charts
