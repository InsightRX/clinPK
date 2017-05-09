library(clinPK)
library(testit)

## NCA
data <- data.frame(cbind(time = c(0, 1, 2, 4, 6, 8),
                         dv   = c(300, 1400, 1150, 900, 700, 400)))
t1 <- nca(data)
assert("NCA estimates are correct (AUCinf)", round(t1$auc_inf) == 9164)
assert("NCA estimates are correct (AUCt)", round(t1$auc_t) == 6824)
assert("NCA estimates are correct (css_t)", round(t1$css) == 853)
assert("NCA estimates are correct (css_tau)", round(t1$css_tau) == 1137)

## NCA with missing data
data <- data.frame(cbind(time = c(0, 1, 2, 4, 6, 8),
                         dv   = c(300, 1400, NA, 900, NA, 400)))
t2 <- nca(data)
assert("NCA estimates are correct (AUCinf)", round(t2$auc_inf) == 8930)
assert("NCA estimates are correct (AUCt)", round(t2$auc_t) == 6711)
assert("NCA estimates are correct (css_t)", round(t2$css) == 839)
assert("NCA estimates are correct (css_tau)", round(t2$css_tau) == 1119)

## BSA
assert("BSA",
       round(calc_bsa(80, 180)$value,2) == 2.00)

## eGFR
err1 <- try(expr = { calc_egfr(scr = .5, weight = 4.5, method = "cockcroft_gault") }, silent=TRUE)
assert("cockcroft-gault error", class(err1[1]) == "character") # error message when no weight specified
assert("cockcroft-gault", round(calc_egfr(age = 40, sex="male", weight = 80, scr = 1, method = "cockcroft_gault")$value) == 111)
assert("cockcroft-gault", round(calc_egfr(age = 40, sex="male", weight = 80, height=180, scr = 1, method = "cockcroft_gault", relative = TRUE)$value) == 96)

assert("cockcroft-gault ibw", round(calc_egfr(age = 50, sex="male", weight = 150, height = 180, scr = 1, method = "cockcroft_gault_adjusted",relative = FALSE)$value) == 131)
assert("cockcroft-gault abw", round(calc_egfr(age = 40, sex="male", weight = 150, height = 180, scr = 1, method = "cockcroft_gault_adjusted", relative = FALSE, factor = 0.3)$value) == 135)
assert("cockcroft-gault abw", round(calc_egfr(age = 40, sex="male", weight = 150, height = 180, scr = 1, method = "cockcroft_gault_ideal", relative = FALSE)$value) == 104)

assert("CKD-EPI", round(calc_egfr(age = 40, sex="male", weight = 80, scr = 1, method = "ckd-epi", race="black")$value) == 123)
assert("MDRD", round(calc_egfr(age = 40, sex="male", weight = 80, height=180, scr = 1, race = "black", method="mdrd")$value) == 106)

err2 <- try(expr = { calc_egfr(age = 40, weight = 80, scr = 1, method = "malmo_lund_revised", relative = FALSE) }, silent=TRUE)
assert("Malmo-Lund error", class(err2[1]) == "character") # error message when no weight specified
assert("Malmo-Lund revised",
       round(calc_egfr(age = 40, sex="male", scr = 1, method = "malmo_lund_revised")$value) == 84)
assert("Malmo-Lund revised",
       round(calc_egfr(age = 40, sex="male", scr = 1, weight = 80, height = 180, method = "malmo_lund_revised", relative = FALSE)$value) == 97)

err3 <- try(expr = { calc_egfr(age = 0.5, scr = .5, weight = 4.5, method = "schwartz") }, silent=TRUE)
assert("Schwartz revised",
       calc_egfr(age = 0.5, sex="male", scr = .5, weight = 4.5, height = 50, method = "schwartz_revised", scr_assay="idms", relative = TRUE)$value == 41.3)
assert("Schwartz error", class(err3[1]) == "character") # error message when no weight specified
assert("Schwartz revised",
       calc_egfr(age = 0.5, sex = "male", scr = .5,  height = 50, method = "schwartz_revised")$value == 41.3)
assert("Schwartz",
       calc_egfr(age = 0.5, sex = "male", scr = .5, weight = 4.5, height = 50, method = "schwartz")$value == 33)

l <- calc_egfr(
  method = "malmo_lund_revised",
  weight = 45,
  age = 62,
  height = 156,
  scr = c(63, 54, 60, 52),
  scr_unit = rep("umol/l", 4),
  sex = "female",
  relative = FALSE)
assert("multiple calc egfr malmo-lund rev", round(l$value) == c(65,73, 67,74))

assert("Jelliffe", round(calc_egfr(age = 40, sex="male", bsa = 1.6, weight = 70, scr = 1, method = "jelliffe")$value) == 76)
# assert("Jelliffe for unstable patients",round(calc_egfr(age = 40, sex="male", bsa = 1.6, weight = 70, scr = 1, method = "jelliffe")$value == 76))
assert("Wright", all(round(calc_egfr(age = 40, sex="male", weight = 80, height=170, scr = c(.5, 1, 1.5), method = "wright")$value) == c(218, 109, 73)))
assert("Wright", all(round(calc_egfr(age = 20, sex="female", weight = 60, height=150, scr = c(.5, 1, 1.5), method = "wright")$value) == c(169, 85, 56)))

## ABW
assert("ABW no height specified", has_error(calc_abw(weight = 80)))   # missing height / ibw
assert("ABW no weight specified", has_error(calc_abw(weight = NULL))) # missing weight
assert("ABW 80kg/180cm", round(calc_abw(weight = 80, height = 180, age = 50), 1) == 77.0)
assert("ABW 50kg/150cm", round(calc_abw(weight = 150, height = 150, age = 20), 1) == 88.7)
assert("ABW wt=50kg, IBW=40", round(calc_abw(weight = 50, ibw = 40), 1) == 44.0)

## IBW
assert("IBW no height specified", has_error(calc_ibw(weight = 80)))   # missing height / ibw
assert("IBW no weight specified", has_error(calc_ibw(weight = NULL))) # missing weight
assert("IBW 80kg/180cm", round(calc_ibw(height = 180, age = 50), 1) == 75.0)
assert("IBW 50kg/150cm", round(calc_ibw(height = 150, age = 20), 1) == 47.8)

## LBW
assert("LBW no height specified", has_error(calc_lbw(weight = 80, sex = "female")))
assert("LBW no weight specified", has_error(calc_lbw(weight = NULL, sex = "female")))
assert("LBW no sex specified", has_error(calc_lbw(weight = 80, height=180)))
assert("LBW 80kg/180cm", round(calc_lbw(weight = 80, height = 180, sex = "female")$value, 1) == 56.4)
assert("LBW 50kg/150cm", round(calc_lbw(weight = 50, height = 150, sex = "male")$value, 1) == 40.8)
assert("LBW output is list", class(calc_lbw(weight = 50, height = 150, sex = "male")) == "list")

## BMI
assert("BMI no height specified", has_error(calc_bmi(weight = 80))) # missing height
assert("BMI 80kg/180cm", round(calc_bmi(weight = 80, height = 180), 1) == 24.7)
assert("BMI 50kg/130cm", round(calc_bmi(weight = 50, height = 130), 1) == 29.6)

## FFM
assert("BMI=20 male 80kg",
       round(calc_ffm (
         weight = 80,
         bmi = 20,
         sex = "male"
       )$value) == 67)
assert("BMI=30 male 80kg",
       round(calc_ffm (
         weight = 80,
         bmi = 30,
         sex = "male"
       )$value) == 56)
assert("BMI=30 female 80kg",
       round(calc_ffm (
         weight = 80,
         bmi = 30,
         sex = "female"
       )$value) == 46)
assert("FFM Al-Sallami",
       round(calc_ffm (
         weight = 60, height = 140, age = 12,
         sex = "female", method = "al-sallami"
       )$value) == 36)

## Test creatinine estimates
assert(calc_creat(sex = c("male", "female"), age = c(20,20))$value == c(84.0, 69.5))
assert(calc_creat(sex = c("male", "female"), age = c(16,16))$value == c(64.9, 60.1))
assert(calc_creat(sex = c("male", "female"), age = c(16,14))$value == c(64.9, 50.6))

## convert creatinine
assert(round(convert_creat_unit(84, unit_in = "mmol/L")$value, 3) == 0.95)
assert(round(convert_creat_unit(1.2, unit_in = "mg/dL")$value,3) == 106.104)
assert(round(convert_creat_unit(1.2)$value,3) == 106.104)

## PK functions
assert("PK 1cmt iv steady state",
  round(tail(pk_1cmt_inf_ss(dose = 100, tau = 12, t_inf = 2, CL = 5, V = 50), 1)$dv,3) == 0.954
)
assert("PK 1cmt iv steady state by summation",
  round(tail(pk_1cmt_inf(dose = 100, tau = 12, t_inf = 2, CL = 5, V = 50, t=seq(from=0, to=10*12, by=.2))$dv,1), 3) == 0.954
)

## Dose calculation for Ctrough:
assert("PK 2cmt infusion dose calculation",
       round(pk_2cmt_inf_dose_from_cmin(cmin = .1, tau = 24, t_inf = 1,
                                  CL = 10, V = 50, Q = 5, V2 = 100), 1) == 84.6)
assert("PK 2cmt bolus dose calculation",
       round(pk_2cmt_bolus_dose_from_cmin(cmin = .1, tau = 24,
                             CL = 10, V = 50, Q = 5, V2 = 100),1) == 86)
assert("PK 1cmt bolus dose calculation",
       round(pk_1cmt_bolus_dose_from_cmin(cmin = .1, tau = 24,
                             CL = 10, V = 50), 1) == 602.6)
assert("PK 1cmt infusion dose calculation",
       round(pk_1cmt_inf_dose_from_cmin(cmin = .1, tau = 24, t_inf = 1,
                           CL = 10, V = 50),1) == 544.3)

## Dose calculation for Cmax:
assert("PK 2cmt bolus dose calculation",
       round(pk_2cmt_bolus_dose_from_cmax(cmax = 10, tau = 24,
                                          CL = 10, V = 50, Q = 5, V2 = 100),1) == 472.5)
assert("PK 2cmt infusion dose calculation",
       round(pk_2cmt_inf_dose_from_cmax(cmax = 10, tau = 24, t_inf = 1,
                                        CL = 10, V = 50, Q = 5, V2 = 100), 1) == 542.4)
assert("PK 1cmt bolus dose calculation",
       round(pk_1cmt_bolus_dose_from_cmax(cmax = 10, tau = 24,
                                          CL = 10, V = 50), 1) == 495.9)
assert("PK 1cmt infusion dose calculation",
       round(pk_1cmt_inf_dose_from_cmax(cmax = 10, tau = 24, t_inf = 1,
                                        CL = 10, V = 50),1) == 547.1)

## Kel estimation
dose <- 1000
V <- 50
kel <- 0.1
CL <- kel * V
conc <- pk_1cmt_inf_ss(t = 10, dose = 1000, tau = 12, t_inf = 1, CL = CL, V = V)
kel_est <- calc_kel_single_tdm(
  dose = 1000,
  V = 50,
  t = 10,
  dv = 11.07,
  tau = 12,
  t_inf = 1,
  kel_init = .1,
  n_iter = 20
)
assert("estimation of elimination rate", abs(kel_est - kel)/kel < 0.05)

## auc2dose
assert("auc2dose empty call", has_error(auc2dose()))
assert("auc2dose ", auc2dose(auc = 500, CL=10, V=100) == 5000)
assert("auc2dose partial auc", round(auc2dose(auc = 500, CL=10, V=100, t_auc = 7)) == 9932)
assert("dose2auc empty call", has_error(dose2auc()))
assert("dose2auc ", dose2auc(dose = 5000, CL=10, V=100) == 500)
assert("dose2auc partial auc", round(dose2auc(dose = 9932, CL=10, V=100, t_auc = 7)) == 500)

## Misc
assert("add RUV all 0", add_ruv(1:100,ruv = list(prop = 0, add = 0, exp = 0)) == 1:100)
assert("add RUV prop err", add_ruv(1:100, ruv = list(prop = 0.1, add = 0, exp = 0)) != 1:100)
assert("add RUV prop err", abs(1-mean(add_ruv(1:100, ruv = list(prop = 0.1, add = 0, exp = 0)) / 1:100)) < 0.04)
assert("add RUV add err", add_ruv(1:100, ruv = list(prop = 0, add = 0.1, exp = 0)) != 1:100)
assert("add RUV exp err", add_ruv(1:100, ruv = list(prop = 0, add = 0, exp = 0.1)) != 1:100)

## conversions
assert("Conc --> mol", conc2mol(conc = 1, mol_weight = 100, unit_conc = "g/L", unit_mol = "mol/L")$value == 0.01)
assert("Conc --> mol", conc2mol(conc = 1, mol_weight = 100, unit_conc = "mg/L", unit_mol = "mol/L")$value == 1e-5)
assert("Mol --> conc", mol2conc(mol = 1, mol_weight = 100, unit_conc = "g/L", unit_mol = "mol/L")$value == 100)
assert("cm --> inch", round(cm2inch(cm = 100), 2) == 39.37)
assert("inch --> cm", round(inch2cm(inch = 39.37), 2) == 100)
assert("kg --> lbs", round(kg2lbs(kg = 100), 2) == 220.46)
assert("lbs --> kg", round(lbs2kg(lbs = 220.462), 2) == 100)

## pct
assert("Pct weight for age", pct_weight_for_age(age = 1, weight = 9, sex="male")$percentile == 26.5)
assert("Pct weight for age", pct_weight_for_age(age = 1, weight = 9, sex="female")$percentile == 51.7)
assert("Pct weight for age", length(names(pct_weight_for_age(age = 1, sex="male"))) > 12)
assert("Pct weight for age", has_error(pct_weight_for_age(weight = 9, sex="male")))
assert("Pct weight for age", has_error(pct_weight_for_age()))
assert("Pct bmi for age", pct_bmi_for_age(age = 2, bmi = 16, sex="male")$percentile == 57.7)
assert("Pct bmi for age", pct_bmi_for_age(age = 6, bmi = 16, sex="female")$percentile == 66.1)
