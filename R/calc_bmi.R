#' Calculate BMI 
#'
#' @param weight weight in kg
#' @param height height in cm
#' @return value of BMI in kg/m2
#' @examples
#' calc_bmi(weight = 70, height = 160)
#' @export
calc_bmi <- function(weight, height) {
  return(weight / (height/100)^2)
}
