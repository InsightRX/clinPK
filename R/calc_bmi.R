#' Calculate BMI
#'
#' @param weight weight in kg
#' @param height height in cm
#' @export
calc_bmi <- function(weight, height) {
  return(weight / (height/100)^2)
}
