# Test two-sample TDM calculation
library(clinPK)
library(testit)

kel1 <- calc_kel_double_tdm(
  dose = 1000,
  t = c(2, 8),
  dv = c(30, 12),
  tau = 8,
  t_inf = 1
)
kel2 <- calc_kel_double_tdm(
  dose = 1000,
  t = c(2, 8),
  dv = c(30, 12),
  tau = 8,
  t_inf = 1,
  steady_state = FALSE,
  return_parameters = TRUE
)
kel3 <- calc_kel_double_tdm(
  dose = 1000,
  t = c(2, 8),
  dv = c(30, 12),
  tau = 8,
  t_inf = 1,
  steady_state = TRUE,
  return_parameters = TRUE
)

kel4 <- calc_kel_double_tdm(
  dose = 1000,
  t = c(2, 8),
  dv = c(30, 12),
  tau = 8,
  t_inf = 1,
  steady_state = TRUE,
  V = 50,
  return_parameters = TRUE
)

assert("kel correct, returned value", kel1 == (log(30/12)/6))
assert("kel correct, not ss, returned parameters", kel2$kel == (log(30/12)/6))
assert("kel correct, not ss, AUC24ss", round(kel2$AUCss24,2) == 740.33)
assert("kel correct, not ss, V", round(kel2$V,2) == 26.53)
assert("kel correct, ss, V", round(kel3$V,2) == 37.62)
assert("kel correct, ss, AUC24ss", round(kel4$AUCss24,2) == 392.89)

