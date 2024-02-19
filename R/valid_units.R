#' Valid units
#'
#' Return recognized units for height, weight, age, scr, serum_albumin.
#'
#' @param covariate Covariate (one of "height", "weight", "age", "scr",
#'   "bilirubin", "serum_albumin")
#' @return Vector of valid units for the given covariate
#' @export
#' @examples
#' valid_units("height")
#' valid_units("weight")
valid_units <- function(
  covariate = c("height", "weight", "age", "scr", "serum_albumin", "bilirubin")
) {
  cov <- match.arg(covariate)
  switch(
    cov,
    height = c("cm", "inch", "inches", "in"),
    weight = c("kg", "lb", "lbs", "pound", "pounds", "oz", "ounce", "ounces", "g", "gram", "grams"),
    scr = c("mg/dl", "mg_dl", "micromol/l", "micromol_l", "micromol", "mmol", "mumol/l", "umol/l", "mumol_l", "umol_l"),
    bilirubin = c("mg/dl", "mg_dl", "micromol/l", "micromol_l", "micromol", "mmol", "mumol/l", "umol/l", "mumol_l", "umol_l"),
    age = c("yrs", "weeks", "days", "years"),
    serum_albumin = c("g_l", "g/l", "g_dl", "g/dl", "micromol/l", "micromol_l", "micromol", "mmol", "mumol/l", "umol/l", "mumol_l", "umol_l")
  )
}
