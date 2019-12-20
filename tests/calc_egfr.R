library(clinPK)
library(testit)

## eGFR
err1 <- try(expr = { calc_egfr(scr = .5, weight = 4.5, method = "cockcroft_gault") }, silent=TRUE)
assert("cockcroft-gault error", class(err1[1]) == "character") # error message when no weight specified
assert("cockcroft-gault", round(calc_egfr(age = 40, sex="male", weight = 80, scr = 1, method = "cockcroft_gault")$value) == 111)
assert("cockcroft-gault", round(calc_egfr(age = 40, sex="male", weight = 80, height=180, scr = 1, method = "cockcroft_gault", relative = TRUE)$value) == 96)
assert("unit_conversion", round(calc_egfr(age = 40, sex="male", weight = 80, scr = 1, scr_unit = 'mg/dl', method = "cockcroft_gault")$value) ==
         round(calc_egfr(age = 40, sex="male", weight = 80, scr = 88.42, scr_unit = 'micromol/L', method = "cockcroft_gault")$value))

assert("cockcroft-gault ibw", round(calc_egfr(age = 50, sex="male", weight = 150, height = 180, scr = 1, method = "cockcroft_gault_adjusted",relative = FALSE)$value) == 131)
assert("cockcroft-gault abw", round(calc_egfr(age = 40, sex="male", weight = 150, height = 180, scr = 1, method = "cockcroft_gault_adjusted", relative = FALSE, factor = 0.3)$value) == 135)
assert("cockcroft-gault abw", round(calc_egfr(age = 40, sex="male", weight = 150, height = 180, scr = 1, method = "cockcroft_gault_ideal", relative = FALSE)$value) == 104)

assert("cockcroft-gault SCI", round(calc_egfr(age = 40, sex="male", weight = 80, height=180, scr = 1, method = "cockcroft_gault_sci", relative = TRUE)$value) == 54)

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
       calc_egfr(age = 0.5, sex = "male", scr = .5, weight = 4.5, height = 50, method = "schwartz")$value == 45)

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

## Test cap
assert("eGFR > upper cap", round(calc_egfr(age = 40, sex="male", weight = 80, scr = .2,
                                          method = "cockcroft_gault")$value) == 556)
tmp1 <- calc_egfr(age = 40, sex="male", weight = 80, scr = .2,
                method = "cockcroft_gault", max_value = 150)
assert("cap applied", tmp1$value == 150)
assert("cap info added: cap", tmp1$capped$max_value == 150)
assert("cap info added: n caps applied", tmp1$capped$n == 1)

assert("eGFR < lower cap", round(calc_egfr(age = 40, sex="male", weight = 80, scr = 3,
                                     method = "cockcroft_gault")$value) == 37)
tmp2 <- calc_egfr(age = 40, sex="male", weight = 80, scr = 3,
                 method = "cockcroft_gault", min_value = 50)
assert("cap info added: cap", tmp2$capped$min_value == 50)
assert("cap info added: no max cap", is.null(tmp2$capped$max_value))
assert("cap info added: n caps applied", tmp2$capped$n == 1)
